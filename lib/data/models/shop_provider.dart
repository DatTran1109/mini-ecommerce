import 'package:flutter/material.dart';

class ShopProvider with ChangeNotifier {
  String _filter = '';
  String _sort = '';
  String _search = '';
  // String _userEmail = '';

  String get filter => _filter;
  String get sort => _sort;
  String get search => _search;
  // String get userEmail => _userEmail;

  void setFilterField(String field) {
    _filter = field;
    notifyListeners();
  }

  void setSortField(String sort) {
    _sort = sort;
    notifyListeners();
  }

  void setSearchField(String search) {
    _search = search;
    notifyListeners();
  }

  // void setUserEmail(String email) {
  //   _userEmail = email;
  //   notifyListeners();
  // }
}
