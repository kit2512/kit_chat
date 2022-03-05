import 'package:flutter/material.dart';
import 'package:kit_chat/models/models.dart';
import 'package:kit_chat/providers/providers.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({
    Key? key,
    required this.conversation,
    required this.name,
  }) : super(key: key);

  final Conversation conversation;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConversationProvider(conversation, name),
      child: _BuildConversationView(),
    );
  }
}

class _BuildConversationView extends StatelessWidget {
  _BuildConversationView({
    Key? key,
  }) : super(key: key);

  final textMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationProvider>(
      builder: (context, conversationProvider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(conversationProvider.name),
        ),
        body: Column(
          children: [
            Expanded(
                child: _BuildMessagesView(
              uid: conversationProvider.conversation.uid,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Pick image
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                    color: const Color.fromARGB(127, 165, 209, 245),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textMessageController
                        ..addListener(
                          () {
                            conversationProvider
                                .setTextMessage(textMessageController.text);
                          },
                        ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await conversationProvider.sendMessage(
                            Provider.of<AuthProvider>(context, listen: false)
                                .user!
                                .uid);
                        textMessageController.clear();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class _BuildMessagesView extends StatelessWidget {
  const _BuildMessagesView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreMethods().conversationMessages(uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.hasData) {
            final messages = snapshot.data! as List<Message>;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 10,
                );
              },
              reverse: true,
              itemBuilder: (context, index) {
                final message = messages[index];
                final currentUid =
                    Provider.of<AuthProvider>(context, listen: false).user!.uid;
                return Align(
                  alignment: message.sender == currentUid
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 325,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: message.sender == currentUid
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(message.content),
                      width: double.infinity,
                    ),
                  ),
                );
              },
              itemCount: messages.length,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
