import 'dart:developer';

import 'package:flutter/material.dart';

class NewChatInputFieldProvider extends ChangeNotifier {
  final TextEditingController textFieldController;

  NewChatInputFieldProvider({required this.textFieldController});

  double scale = 0;
  bool isText = false;

  void onTextFieldValueChanged(String value) {
    if (value.length > 0) {
      isText = true;
      notifyListeners();
    } else {
      isText = false;
      notifyListeners();
    }
  }

  void onSendButtonClicked() {
    if (isText) {
      // _scrollController.animateTo(
      //     _scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.easeOut);

      textFieldController.clear();

      isText = false;
      notifyListeners();
    }
  }

  void onLongPressDragChange(double value) {
    double x = -value / 200;
    scale = x;
    notifyListeners();
  }

  void onLongPress() {
    if (!isText) {
      log('start recording');
    }
  }
}
