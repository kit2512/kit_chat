import 'package:flutter/material.dart';
import 'package:kit_chat/resources/firestore_methods.dart';

class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  bool isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  String get searchText => _searchText;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  void setSearchText(String value) async {
    if (value.isEmpty) {
      _searchText = value;
      _searchResults = [];
      notifyListeners();
    } else {
      _searchText = value;
      _searchResults = await FirestoreMethods().searchUsers(value);
      notifyListeners();
    }
  }
}
