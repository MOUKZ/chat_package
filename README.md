# chat_package

Flutter chat ui with full voice record/note functionality and image sending

# Chat UI Package
[![Pub]](https://pub.dev/packages/chat_package)

An easy to implement whatssapp like chat ui. with voice note feature and image viewing. 

## Screenshots

<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/1.jpeg" height="500em"><img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/2.jpeg" height="500em">
<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/3.jpeg" height="500em">
<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/4.jpeg" height="500em">

## Usage

the list of ChatMessages is the only required feild every thing else is optional
```
List<ChatMessage> messages = [
    ChatMessage(
        isSender: true,
        imageUrl:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
    ChatMessage(isSender: false, text: 'wow that is cool'),
  ];
```
-- plese note that only one of the following [text,imageUrl,imagePath,audioUrl,audioPath ] must not be null at a time if more is provided an error will occure 
```
ChatMessage(isSender: false, text: 'your.text')
ChatMessage(isSender: false, imageUrl: image.url')
ChatMessage(isSender: false, imagePath: 'image.path')
ChatMessage(isSender: false, audioUrl: 'wow that is cool')
ChatMessage(isSender: false, audioPath: 'wow that is cool')
```
```
 ChatScreen(
          messages: messages,
        )
```

## Properties
```dart
 /// The button widget used on the moving element of the slider. Defaults to Icon(Icons.chevron_right).
  final Widget sliderButtonContent;
  //hit text to be shown for sending messages
  final String sendMessageHintText;

  //hit text to be shown for recording voice note
  final String recordinNoteHintText;

  /// The Icon showed to send a text
  final IconData sendTextIcon;
  // texts shown wen trying to chose image attachment
  final String imageAttachmentFromGalary;
  final String imageAttachmentFromCamery;
  final String imageAttachmentCancelText;
  // image attachment text color
  final Color imageAttachmentTextColor;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color containerColor;

  /// The callback when slider is completed. This is the only required field.
  final VoidCallback onSlideToCancelRecord;

  //The callback when send is pressed.
  Function(String? text)? onSubmit;

  /// function to handle the selected image
  final Function(XFile) handleImageSelect;

  /// function to handle the recorded audio
  final Function(String? path, bool cnaceled)? handleRecord;

  final TextEditingController textController;

```

