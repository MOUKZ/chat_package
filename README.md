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


the list of ChatMessages is the only required feild every thing else is optional
```dart
List<ChatMessage> messages = [
    ChatMessage(
        isSender: true,
        imageUrl:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
    ChatMessage(isSender: false, text: 'wow that is cool'),
  ];
```
-- plese note that only one of the following [text,imageUrl,imagePath,audioUrl,audioPath ] must not be null at a time if more is provided an error will occure 
```dart
ChatMessage(isSender: false, text: 'your.text')
ChatMessage(isSender: false, imageUrl: image.url')
ChatMessage(isSender: false, imagePath: 'image.path')
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
  // use this flag to disable the input
  final bool disableInput;

```

