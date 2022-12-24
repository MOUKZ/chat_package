import 'dart:io';

import 'package:flutter/material.dart';

class CapturedMediaView extends StatelessWidget {
  final String path;
  final String? capturedMediaHintText;
  final Function(String path, String? caption) onSubmitMediaFromCamera;

  CapturedMediaView(
      {Key? key,
      required this.path,
      required this.onSubmitMediaFromCamera,
      this.capturedMediaHintText})
      : super(key: key);
  String caption = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.crop_rotate,
        //         size: 27,
        //       ),
        //       onPressed: () {}),
        //   IconButton(
        //       icon: Icon(
        //         Icons.emoji_emotions_outlined,
        //         size: 27,
        //       ),
        //       onPressed: () {}),
        //   IconButton(
        //       icon: Icon(
        //         Icons.title,
        //         size: 27,
        //       ),
        //       onPressed: () {}),
        //   IconButton(
        //       icon: Icon(
        //         Icons.edit,
        //         size: 27,
        //       ),
        //       onPressed: () {}),
        // ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  onChanged: (value) {
                    caption = value;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: capturedMediaHintText ?? 'Add Caption....',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: IconButton(
                            onPressed: () {
                              onSubmitMediaFromCamera(path, caption);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 27,
                            )),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
