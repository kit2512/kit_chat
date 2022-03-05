import 'package:flutter/material.dart';
import 'package:kit_chat/models/models.dart';
import 'package:kit_chat/providers/auth_provider.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:kit_chat/resources/resources.dart';
import 'package:kit_chat/screens/screens.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethods().signOut();
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          )
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: ((context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ConversationListScreen(
              conversationIds: authProvider.user!.conversations);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SearchScreen(),
          ));
        },
      ),
    );
  }
}

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({Key? key, required this.conversationIds})
      : super(key: key);

  final List<String> conversationIds;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Conversation>>(
      future: FirestoreMethods().conversations(conversationIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {}
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _BuildConversationTile(
                conversation: snapshot.data![index],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}

class _BuildConversationTile extends StatelessWidget {
  const _BuildConversationTile({Key? key, required this.conversation})
      : super(key: key);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: FirestoreMethods().getConversationTileInfo(conversation),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const ListTile();
        }
        final data = snapshot.data!;
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ConversationScreen(
                conversation: conversation,
                name: data["name"],
              );
            }));
          },
          title: Text(data['name']),
          leading: data["profileImage"].isEmpty
              ? const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/user_dummy.png"),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(data["profileImage"]),
                ),
        );
      },
    );
  }
}
