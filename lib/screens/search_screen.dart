import 'package:flutter/material.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:kit_chat/screens/screens.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: _BuildSearchView(searchTextController: searchTextController),
    );
  }
}

class _BuildSearchView extends StatelessWidget {
  const _BuildSearchView({
    Key? key,
    required this.searchTextController,
  }) : super(key: key);

  final TextEditingController searchTextController;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchTextController
                ..addListener(() {
                  searchProvider.setSearchText(searchTextController.text);
                }),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                suffixIcon: searchProvider.searchText.isNotEmpty
                    ? IconButton(
                        color: Colors.white,
                        onPressed: () {
                          searchTextController.clear();
                        },
                        icon: const Icon(Icons.clear))
                    : null,
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(microseconds: 500),
            child: searchProvider.searchText.isEmpty
                ? const Center(
                    child: Text("Start typing to search"),
                  )
                : searchProvider.searchResults.isEmpty
                    ? const Center(
                        child: Text("No results found"),
                      )
                    : _BuildResultList(
                        resultsList: searchProvider.searchResults,
                      ),
          ),
        );
      },
    );
  }
}

class _BuildResultList extends StatelessWidget {
  const _BuildResultList({Key? key, required this.resultsList})
      : super(key: key);

  final List<Map<String, dynamic>> resultsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        final result = resultsList[index];
        return _BuildResultTile(result: result);
      }),
      itemCount: resultsList.length,
    );
  }
}

class _BuildResultTile extends StatelessWidget {
  void _getConversation(BuildContext context, AuthProvider authProvider) async {
    final conversation =
        await FirestoreMethods().getConversation(result["uid"]);
    if (!authProvider.user!.conversations.contains(conversation.uid)) {
      authProvider.user!.conversations.add(conversation.uid);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return ConversationScreen(
        conversation: conversation,
        name: result["name"],
      );
    }));
  }

  const _BuildResultTile({
    Key? key,
    required this.result,
  }) : super(key: key);

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => ListTile(
        onTap: () => _getConversation(context, authProvider),
        title: Text(result["name"] as String),
        leading: result["profileImage"].isEmpty
            ? const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                  "assets/images/user_dummy.png",
                ),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(
                  result["profileImage"] as String,
                ),
              ),
      ),
    );
  }
}
