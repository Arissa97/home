import 'package:flutter/material.dart';

class MainStore extends ChangeNotifier {
  bool _islogin = false;

  bool islogin() => _islogin;

  setIslogin(bool islogin) {
    _islogin = islogin;
    // notifyListeners();
  }
}
