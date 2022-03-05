import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kit_chat/models/models.dart' as app_models;
import 'package:kit_chat/models/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<app_models.User> getUserDetails(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(uid).get();
    log("AuthProvider: getUserDetails: ${documentSnapshot.data()}");

    return app_models.User.fromSnapshot(
        documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> createNewUserData(app_models.User user) async {
    await _firestore.collection("users").doc(user.uid).set(user.toJson());
  }

  Future<List<app_models.Conversation>> conversations(
      List<String> conversationIds) async {
    if (conversationIds.isEmpty) {
      return [];
    } else {
      final snapshot = await _firestore
          .collection("conversations")
          .where("uid", whereIn: conversationIds)
          .get();
      return snapshot.docs
          .map((doc) => app_models.Conversation.fromSnapshot(doc.data()))
          .toList();
    }
  }

  Future<app_models.Conversation> getConversation(String receiverId) async {
    final members = [_auth.currentUser!.uid, receiverId];
    final existedConversationSnapshot = await _firestore
        .collection("conversations")
        .where("members", isEqualTo: members)
        .limit(1)
        .get();
    if (existedConversationSnapshot.docs.isEmpty) {
      final conversation = app_models.Conversation(
        members: members,
        uid: const Uuid().v1(),
      );
      await _firestore
          .collection("conversations")
          .doc(conversation.uid)
          .set(conversation.toJson());
      await _firestore.collection("users").doc(receiverId).update({
        "conversations": FieldValue.arrayUnion([conversation.uid])
      });
      log("AuthProvider: getConversation: created new conversation");
      return conversation;
    } else {
      log("AuthProvider: getConversation: return existed conversation");
      final conversationSnapshot = existedConversationSnapshot.docs.first;
      return app_models.Conversation.fromSnapshot(conversationSnapshot.data());
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    final query = _firestore
        .collection("users")
        .where("name",
            isGreaterThanOrEqualTo: keyword,
            isNotEqualTo: _auth.currentUser!.uid)
        .limit(10)
        .orderBy("name", descending: true);
    final resultSnapshot = await query.get();
    final filteredResults = resultSnapshot.docs
        .map(
          (doc) {
            return {
              "uid": doc.id,
              "name": doc.data()["name"],
              "profileImage": doc.data()["profileImage"]
            };
          },
        )
        .where((element) => element["uid"] != _auth.currentUser!.uid)
        .toList();
    return filteredResults;
  }

  Future<Map<String, dynamic>> getConversationTileInfo(
      app_models.Conversation conversation) async {
    final currentId = _auth.currentUser!.uid;
    final otherId =
        conversation.members.firstWhere((element) => element != currentId);
    final snapshot = await _firestore
        .collection("users")
        .where("uid", isEqualTo: otherId)
        .limit(1)
        .get();
    return {
      "name": snapshot.docs.first.data()["name"],
      "profileImage": snapshot.docs.first.data()["profileImage"],
      "conversationId": conversation.uid,
    };
  }

  Stream<List<Message>> conversationMessages(String uid) async* {
    final snapshot = _firestore
        .collection("conversations/$uid/messages")
        .orderBy("time", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromJson(doc.data());
      }).toList();
    });
    yield* snapshot;
  }

  Future<void> sendMessage(String uid, Message message) {
    return _firestore
        .collection("conversations/$uid/messages")
        .doc(message.uid)
        .set(message.toJson());
  }
}
