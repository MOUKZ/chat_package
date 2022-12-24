import 'dart:developer';

import 'package:chat_package/components/new_chat_input_field/send_button.dart';
import 'package:flutter/material.dart';
import './text_field.dart';

import 'attachment_bottom_sheet.dart';

class NewChatInputField extends StatefulWidget {
  NewChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<NewChatInputField> {
  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  TextEditingController _controller = TextEditingController();
  // ScrollController _scrollController = ScrollController();
  double scale = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * (1 - scale);
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: width,
      child: WillPopScope(
        child: Row(
          children: [
            CustomTextField(
              width: width * (0.85 - scale),
              focusNode: focusNode,
              controller: _controller,
              onChanged: (value) {
                if (value.length > 0) {
                  setState(() {
                    sendButton = true;
                  });
                } else {
                  setState(() {
                    sendButton = false;
                  });
                }
              },
              onAttachmentClicked: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (builder) => AttachmentBottomSheet());
              },
            ),
            SendButton(
              onDragChange: (p0) {
                setState(() {
                  double x = -p0 / 200;
                  scale = x;
                });
              },
              onPressed: () {
                if (sendButton) {
                  // _scrollController.animateTo(
                  //     _scrollController.position.maxScrollExtent,
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.easeOut);

                  _controller.clear();
                  setState(() {
                    sendButton = false;
                  });
                }
              },
              onLongPress: () {
                if (!sendButton) {
                  log('start recording');
                }
              },
              sendButton: sendButton,
            ),
          ],
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
      ),
    );
  }
}
