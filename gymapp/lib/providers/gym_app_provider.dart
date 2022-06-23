import 'package:flutter/material.dart';

class Flag with ChangeNotifier {
  bool _flag = true;
  bool get flag => _flag;
  void setFlag(bool value) {
    _flag = value;
    notifyListeners();
  }
}
