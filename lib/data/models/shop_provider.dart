import 'package:flutter/material.dart';

class ShopProvider with ChangeNotifier {
  String _filter = '';
  String _sort = '';
  String _search = '';

  String get filter => _filter;
  String get sort => _sort;
  String get search => _search;

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
}
