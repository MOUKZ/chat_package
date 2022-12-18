# chat_package
![Pub Version](https://img.shields.io/pub/v/chat_package?color=blue) ![likes](https://img.shields.io/pub/likes/chat_package) ![popularity](https://img.shields.io/pub/popularity/chat_package) <a href="https://github.com/MOUKZ/chat_package" target="_blank">![GitHub](https://img.shields.io/github/stars/MOUKZ/chat_package)</a>



Flutter chat ui with full voice record/note functionality and image sending

### Created by Omar Mouki
<a href="https://github.com/MOUKZ">![GitHub](https://img.shields.io/badge/Github-808080?style=for-the-badge&logo=github&logoColor=white)</a> <a href="https://www.linkedin.com/in/omar-mouki"> ![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)</a> <a href="mailto:omar.mouki@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"></a>

# Chat UI Package
![Pub](https://img.shields.io/pub/v/chat_package)

An easy to implement whatsapp like chat ui. with voice note feature and image viewing. 

## Screenshots


<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/1.jpeg" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/2.jpeg" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/3.jpeg" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/4.jpeg" height="400em">

## Usage

### Permission Setup
This package uses [permission_handler](https://pub.dev/packages/permission_handler) plugin to access permissions,
and the following permissions are required:
 1. camera
 2. microphone
 3. local storage

#### Android
1. Add the following to your "gradle.properties" file:
```
android.useAndroidX=true
android.enableJetifier=true
```
2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 30:
```
android {
  compileSdkVersion 30
  ...
}
```
3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found here: https://developer.android.com/jetpack/androidx/migrate).

Add permissions to your `AndroidManifest.xml` file.
```xml
 <uses-permission android:name="android.permission.INTERNET"/>
    <!-- Permissions options for the `storage` group -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <!-- Permissions options for the `camera` group -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <!-- Permissions options for the `RECORD_AUDIO` group -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
```
#### IOS
```xml
    <!-- Permission options for the `camera` group -->
    <key>NSCameraUsageDescription</key>
    <string>camera</string>
    <!-- Permission options for the `microphone` group -->
    <key>NSMicrophoneUsageDescription</key>
    <string>microphone</string>
    <!-- Permission options for the `photos` group -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>photos</string>

```

### Calling


the list of ChatMessages is the only required field every thing else is optional
```dart
List<ChatMessage> messages = [
    ChatMessage(
        isSender: true,
        imageUrl:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
    ChatMessage(isSender: false, text: 'wow that is cool'),
  ];
```
-- please note that only one of the following [text,imageUrl,imagePath,audioUrl,audioPath ] must not be null at a time if more is provided an error will occure 
```dart
ChatMessage(isSender: false, text: 'your.text')
ChatMessage(isSender: false, imageUrl: image.url)
ChatMessage(isSender: false, imagePath: image.path)
ChatMessage(isSender: false, audioUrl: 'wow that is cool')
ChatMessage(isSender: false, audioPath: 'wow that is cool')
```
```dart
 ChatScreen(
          messages: messages,
        )
```

## Properties
```dart
 ///color of all message containers if its belongs to the user
  final Color? senderColor;

  ///color of the inactive part of the audio slider
  final Color? inActiveAudioSliderColor;

  ///color of the active part of the audio slider
  final Color? activeAudioSliderColor;

  ///scrollController for the chat screen
  final ScrollController? scrollController;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color chatInputFieldColor;

  ///hint text to be shown for sending messages
  final String sendMessageHintText;

  /// texts shown wen trying to chose image attachment
  final String imageAttachmentFromGalleryText;
  final String imageAttachmentFromCameraText;
  final String imageAttachmentCancelText;
  final TextStyle? imageAttachmentTextStyle;

  ///hint text to be shown for recording voice note
  final String recordingNoteHintText;

  /// handel [text message] on submit
  final Function(String? text)? onSubmit;

  /// [required] the list of chat messages
  final List<ChatMessage> messages;

  /// function to handel successful recordings, bass to override
  final Function(String? path, bool canceled)? handleRecord;

  /// function to handel image selection
  final Function(XFile)? handleImageSelect;

  /// to handel canceling of the record
  final VoidCallback? onSlideToCancelRecord;

  ///TextEditingController to handel input text
  final TextEditingController? textEditingController;

  final BoxDecoration? chatInputFieldDecoration;

  /// use this flag to disable the input
  final bool disableInput;

  /// git the chat input field padding
  final EdgeInsets? chatInputFieldPadding;

```
## Found this project useful?

If you found this project useful, then please consider giving it a ⭐️ on Github and why don't you share it with your friends.


## Issues and feedback

Feel free to open a Github [issue](https://github.com/MOUKZ/chat_package/issues) to give a suggestion.

