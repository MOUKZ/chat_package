# chat_package
![Pub Version](https://img.shields.io/pub/v/chat_package?color=blue) ![likes](https://img.shields.io/pub/likes/chat_package) ![popularity](https://img.shields.io/pub/popularity/chat_package) <a href="https://github.com/MOUKZ/chat_package" target="_blank">![GitHub](https://img.shields.io/github/stars/MOUKZ/chat_package)</a> ![Pub](https://img.shields.io/pub/v/chat_package)



This package provides an easy-to-implement chat UI in your flutter project with audio recording and image-sending support.<br>
This package also is highly customizable to suit your project.
 

### Created by Omar Mouki
<a href="https://github.com/MOUKZ">![GitHub](https://img.shields.io/badge/Github-808080?style=for-the-badge&logo=github&logoColor=white)</a> <a href="https://www.linkedin.com/in/omar-mouki"> ![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)</a> <a href="mailto:omar.mouki@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"></a>


## Screenshots


<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/home_screen.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/recording.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/bottom_sheet.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/permission.png" height="400em">


## Coming Soon

The next update of this package will add the support of recording videos, adding caption to captured/storage images, and much more features.
## Usage

### Permission Setup
You only have to add permissions in your project and the package will do the rest.
The following permissions are required:
 1. camera
 2. microphone
 3. local storage

#### Android
1. Add the following to your "gradle.properties" file:
```
android.useAndroidX=true
android.enableJetifier=true
```
2. In order to use the recording feature, make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 21:
```
android {
  compileSdkVersion 21
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
add this to your Podfile
```ruby
  target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        'PERMISSION_CAMERA=1',
        'PERMISSION_MICROPHONE=1',
        'PERMISSION_PHOTOS=1',

      ]

    end
```

### Calling


Simply call the ```ChatScreen```<br>
ChatMessages: the chat screen requires a list of chat messages, and to make it easy, the ```ChatMessage``` model contains a ```fromJson()``` method
so you can iterate the list of stored ```ChatMessage``` from your back-end, and an example of a ```ChatMessage```
```dart
ChatMessage(
      isSender: true,
      text: 'this is a banana',
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.imageMediaType(),
      ),
    )
```
This package also provides you with a ```ChatMessage``` model when using these required methods```onTextSubmit```, ```handleRecord``` ,
```handleImageSelect``` and the full code will be like this: 

```dart
 ChatScreen(
        scrollController: scrollController,
        messages: messages,
        onSlideToCancelRecord: () {
          log('not sent');
        },
        onTextSubmit: (textMessage) {
          setState(() {
            messages.add(textMessage);

            scrollController
                .jumpTo(scrollController.position.maxScrollExtent + 50);
          });
        },
        handleRecord: (audioMessage, canceled) {
          if (!canceled) {
            setState(() {
              messages.add(audioMessage!);
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent + 90);
            });
          }
        },
        handleImageSelect: (imageMessage) async {
          if (imageMessage != null) {
            setState(() {
              messages.add(
                imageMessage,
              );
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent + 300);
            });
          }
        },
      )
```

## Properties
You can customize almost everything in this package and here is the entire properties that you can change.
```dart
 ///color of all message containers if its belongs to the user
  final Color? senderColor;

  ///color of the inactive part of the audio slider
  final Color? inActiveAudioSliderColor;

  ///color of the active part of the audio slider
  final Color? activeAudioSliderColor;

  ///[required]scrollController for the chat screen
  final ScrollController scrollController;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color chatInputFieldColor;

  ///hint text to be shown for sending messages
  final String sendMessageHintText;

  /// these parameters for changing the text and icons in the [attachment-bottom-sheet]
  /// text shown wen trying to chose image attachment from gallery in attachment
  /// bottom sheet
  final String imageAttachmentFromGalleryText;

  /// Icon shown wen trying to chose image attachment from gallery in attachment
  /// bottom sheet
  final Icon? imageAttachmentFromGalleryIcon;

  /// text shown wen trying to chose image attachment from camera in attachment
  /// bottom sheet
  final String imageAttachmentFromCameraText;

  /// Icon shown wen trying to chose image attachment from camera in attachment
  /// bottom sheet
  final Icon? imageAttachmentFromCameraIcon;

  /// text shown wen trying to chose image attachment cancel text in attachment
  /// bottom sheet
  final String imageAttachmentCancelText;

  /// Icon shown wen trying to chose image attachment cancel text in attachment
  /// bottom sheet
  final Icon? imageAttachmentCancelIcon;

  /// image attachment text style in attachment
  /// bottom sheet
  final TextStyle? imageAttachmentTextStyle;

  ///hint text to be shown for recording voice note
  final String recordingNoteHintText;

  /// [required] handel [text message] on submit
  /// this method will pass a [ChatMessage]
  final Function(ChatMessage textMessage) onTextSubmit;

  /// [required] the list of chat messages
  final List<ChatMessage> messages;

  /// [required] function to handel successful recordings, bass to override
  /// this method will pass a [ChatMessage] and if the used [canceled] the recording
  final Function(ChatMessage? audioMessage, bool canceled) handleRecord;

  /// [required] function to handel image selection
  /// this method will pass a [ChatMessage]
  final Function(ChatMessage? imageMessage) handleImageSelect;

  /// to handel canceling of the record
  final VoidCallback? onSlideToCancelRecord;

  ///TextEditingController to handel input text
  final TextEditingController? textEditingController;

  /// to change the appearance of the chat input field
  final BoxDecoration? chatInputFieldDecoration;

  /// use this flag to disable the input
  final bool disableInput;

  /// git the chat input field padding
  final EdgeInsets? chatInputFieldPadding;

  /// text style for the message container
  final TextStyle? messageContainerTextStyle;

  /// text style for the message container date
  final TextStyle? sendDateTextStyle;

  /// this is an optional parameter to override the default attachment bottom sheet
  final Function(BuildContext context)? attachmentClick;

```
## Found this project useful?

If you found this project useful, then please consider giving it a ⭐️ on Github and why don't you share it with your friends.


## Issues and feedback

Feel free to open a Github [issue](https://github.com/MOUKZ/chat_package/issues) to give a suggestion.

