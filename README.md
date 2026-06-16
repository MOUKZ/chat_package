# chat_package

![Pub Version](https://img.shields.io/pub/v/chat_package?color=blue) ![likes](https://img.shields.io/pub/likes/chat_package) ![popularity](https://img.shields.io/pub/popularity/chat_package) <a href="https://github.com/MOUKZ/chat_package" target="_blank">![GitHub](https://img.shields.io/github/stars/MOUKZ/chat_package)</a>

A ready-made, highly customizable **chat UI** for Flutter. Drop in `ChatScreen`,
wire up a handful of callbacks, and you get text messages, voice notes with
slide-to-cancel, gallery images, an in-app camera, and video messages — out of
the box.

### Created by Omar Mouki
<a href="https://github.com/MOUKZ">![GitHub](https://img.shields.io/badge/Github-808080?style=for-the-badge&logo=github&logoColor=white)</a> <a href="https://www.linkedin.com/in/omar-mouki"> ![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)</a> <a href="mailto:omar.mouki@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"></a>

## Features

- 💬 **Text messages** with a customizable input field
- 🎙️ **Voice notes** — hold to record, slide to cancel, built-in playback with a seek slider
- 🖼️ **Images** from the gallery, shown inline with a full-screen viewer
- 📷 **In-app camera** — capture photos and videos with a caption step
- 🎞️ **Video messages** — inline thumbnail with tap-to-play full screen
- 🎨 **Highly customizable** — colors, sizes, text direction (LTR/RTL), icons, hints and more
- 🧩 Callback-driven: you own your data and state

## Screenshots

<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/home_screen.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/recording.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/bottom_sheet.png" height="400em"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/permission.png" height="400em">

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  chat_package: ^2.1.0
```

Then run `flutter pub get`.

Requires **Dart >= 3.0** and **Flutter >= 3.16**.

## Platform setup

The package requests the runtime permissions it needs (microphone, camera,
photos) for you — you only need to declare them.

### Android

In `android/app/build.gradle`, make sure the minimum SDK is at least **23**
(required by the audio recorder):

```gradle
android {
    defaultConfig {
        minSdkVersion 23
    }
}
```

Add the permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<!-- Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<!-- Older Android versions -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS

Add the usage descriptions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos and videos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record voice notes.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to attach images.</string>
```

And enable the matching `permission_handler` macros in `ios/Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_MICROPHONE=1',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

## Quick start

```dart
import 'package:chat_package/chat_package.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final scrollController = ScrollController();
  final List<ChatMessage> messages = [
    ChatMessage(isSender: false, text: 'Welcome to chat_package 👋'),
  ];

  void _add(ChatMessage m) => setState(() => messages.add(m));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: ChatScreen(
        scrollController: scrollController,
        messages: messages,
        onTextSubmit: _add,
        handleRecord: (audio, canceled) {
          if (!canceled && audio != null) _add(audio);
        },
        handleImageSelect: (image) {
          if (image != null) _add(image);
        },
        handleVideoSelect: (video) {
          if (video != null) _add(video);
        },
      ),
    );
  }
}
```

### The `ChatMessage` model

A message holds optional `text` and optional `ChatMedia` (an image/audio/video
url or local file path). It also offers `toJson()` / `fromJson()` so you can
persist and restore conversations from your backend.

```dart
ChatMessage(
  isSender: true,
  text: 'this is a banana',
  chatMedia: ChatMedia(
    url: 'https://example.com/banana.jpg',
    mediaType: MediaType.image, // image | audio | video
  ),
);
```

> **Note:** `MediaType` is now a plain enum (`MediaType.image`, `MediaType.audio`,
> `MediaType.video`). See the migration guide below.

## API reference

### Required

| Property | Type | Description |
|---|---|---|
| `messages` | `List<ChatMessage>` | The messages to render. |
| `scrollController` | `ScrollController` | Controls the chat list. |
| `onTextSubmit` | `Function(ChatMessage)` | Called when a text message is sent. |
| `handleRecord` | `Function(ChatMessage?, bool canceled)` | Called with the recorded voice note (or `(null, true)` when canceled). |
| `handleImageSelect` | `Function(ChatMessage?)` | Called with the selected/captured image (or `null`). |

### Common optional

| Property | Type | Default | Description |
|---|---|---|---|
| `handleVideoSelect` | `Function(ChatMessage?)?` | `null` | Captured video callback; falls back to `handleImageSelect` if omitted. |
| `onSlideToCancelRecord` | `VoidCallback?` | `null` | Called when a recording is slid to cancel. |
| `textEditingController` | `TextEditingController?` | internal | Supply your own controller for the input text. |
| `disableInput` | `bool` | `false` | Disables the whole input field. |
| `attachmentClick` | `Function(BuildContext)?` | default sheet | Override the attachment bottom sheet. |

### Appearance & layout

| Property | Type | Default |
|---|---|---|
| `senderColor` | `Color?` | theme default |
| `activeAudioSliderColor` / `inActiveAudioSliderColor` | `Color?` | theme defaults |
| `chatInputFieldColor` | `Color` | `Color(0xFFCFD8DC)` |
| `chatInputFieldDecoration` | `BoxDecoration?` | `null` |
| `chatInputFieldPadding` | `EdgeInsets?` | `null` |
| `messageContainerTextStyle` / `sendDateTextStyle` | `TextStyle?` | `null` |
| `textDirection` | `TextDirection` | `TextDirection.ltr` |
| `containerBorderRadius` | `double` | `40` |
| `buttonRadius` | `double` | `35` |
| `textMessageWidthFraction` | `double` | `0.5` |
| `imageMessageWidthFraction` | `double` | `0.45` |
| `audioMessageWidthFraction` | `double` | `0.7` |

### Capture quality

| Property | Type | Default |
|---|---|---|
| `cameraResolution` | `ResolutionPreset` | `ResolutionPreset.high` |
| `audioBitRate` | `int` | `128000` |
| `imageQuality` | `int` | `70` |
| `imageMaxWidth` | `double` | `1440` |

### Attachment bottom sheet labels & icons

`imageAttachmentFromGalleryText` / `Icon`, `imageAttachmentFromCameraText` /
`Icon`, `imageAttachmentCancelText` / `Icon`, `imageAttachmentTextStyle`,
`sendMessageHintText`, `recordingNoteHintText`.

## Migration to 2.x

- **SDK:** requires Dart `>=3.0` / Flutter `>=3.16`.
- **`MediaType` is now an enum.** Replace `MediaType.imageMediaType()` →
  `MediaType.image`, `MediaType.audioMediaType()` → `MediaType.audio`,
  `MediaType.videoMediaType()` → `MediaType.video`. (The Freezed dependency was
  removed.)
- **New `handleVideoSelect` callback** for the in-app camera's video captures.
- **In-app camera** now returns captured photos/videos into the chat (with an
  optional caption). The attachment camera option opens the in-app camera.
- **Android `minSdkVersion` must be `>= 23`** for the upgraded audio recorder.
- New customization params: `textDirection`, `containerBorderRadius`,
  `buttonRadius`, message width fractions, and capture-quality settings.

## Found this project useful?

If this package helped you, please consider giving it a ⭐️ on
[GitHub](https://github.com/MOUKZ/chat_package) and sharing it.

## Issues and feedback

Open an issue on [GitHub](https://github.com/MOUKZ/chat_package/issues) with
suggestions, bugs or feature requests.

## License

MIT © Omar Mouki
