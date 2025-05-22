![Pub Version](https://img.shields.io/pub/v/chat_package?color=blue) ![likes](https://img.shields.io/pub/likes/chat_package) ![popularity](https://img.shields.io/pub/popularity/chat_package) [![GitHub Stars](https://img.shields.io/github/stars/MOUKZ/chat_package)](https://github.com/MOUKZ/chat_package)

A highly customizable Flutter chat UI package with built‑in:

- Text messaging
- Press‑and‑hold audio recording with slide‑to‑cancel
- Image picking (camera & gallery)
- Complete style hooks for every component

Created by Omar Mouki ([GitHub](https://github.com/MOUKZ)) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/omar-mouki) [![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:omar.mouki@gmail.com)

---

## 📸 Screenshots

<img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/home_screen.png" height="250"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/recording.png" height="250"> <img src="https://raw.githubusercontent.com/MOUKZ/chat_package/main/screenShots/bottom_sheet_1.png" height="250">

---

## 🚀 Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  chat_package: ^<latest-version>
```

Run:

```bash
flutter pub get
```

---

### 🔐 Permission Setup

#### Android

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
    <!-- Audio recording -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <!-- Microphone/audio settings -->
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />

    <!-- Camera capture -->
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Optional: to save recordings in public storage (legacy) -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                     android:maxSdkVersion="28" />

    <!-- Gallery access -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <!-- On Android 13+ you may also need these for image/video access -->

    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
```

Ensure in `android/app/build.gradle`:

```groovy
android {
  compileSdk = 35
  namespace "com.yourapp.namespace"
  // …
}
```

#### iOS

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture photos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to pick images.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs permission to save photos.</string>
```

---

## 🎨 Customization API

### `ChatScreen`

A full‑screen chat UI:

```dart
ChatScreen(
  scrollController: _scrollCtrl,
  messages: myChatMessages,
  senderColor: Colors.blue,
  receiverColor: Colors.grey.shade200,
  activeAudioSliderColor: Colors.blueAccent,
  inactiveAudioSliderColor: Colors.grey,
  chatInputFieldColor: Colors.white,
  chatInputFieldDecoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(16),
  ),
  onTextSubmit: (msg) => setState(() => messages.add(msg)),
  handleRecord: (audioMsg, canceled) { /* … */ },
  handleImageSelect: (imgMsg) { /* … */ },
  onSlideToCancelRecord: () { /* … */ },
)
```

#### Key Props

- `senderColor` / `receiverColor`
- `activeAudioSliderColor` / `inactiveAudioSliderColor`
- `messageContainerTextStyle` / `sendDateTextStyle`
- `chatInputFieldColor`, `chatInputFieldDecoration`, `chatInputFieldPadding`

### `ChatInputField`

Just the input row:

```dart
ChatInputField(
  onSend: (text) { /*…*/ },
  onRecordComplete: (audioMsg, canceled) { /*…*/ },
  textController: TextEditingController(),
  cancelThreshold: 120,
  showWaveAnimation: true,
  waveDuration: Duration(milliseconds: 800),
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(32),
  ),
  inputDecoration: InputDecoration.collapsed(hintText: 'Type...'),
  waveStyle: WaveAnimationStyle(
    barCount: 6,
    barColor: Colors.green,
    minBarHeight: 6,
    maxBarHeight: 20,
  ),
  buttonStyle: RecordingButtonStyle(
    buttonColor: Colors.green,
    iconColor: Colors.white,
    padding: EdgeInsets.all(14),
    sendIcon: Icons.send_rounded,
    micIcon: Icons.mic_none,
  ),
)
```

#### `WaveAnimationStyle`

- `barCount`, `barColor`, `barWidth`, `barSpacing`
- `minBarHeight`, `maxBarHeight`, `barBorderRadius`

#### `RecordingButtonStyle`

- `buttonColor`, `iconColor`, `iconSize`
- `padding`, `sendIcon`, `micIcon`
- `decoration`, `switchDuration`, `switchCurve`

---

## 📦 Models

### `ChatMessage`

```dart
ChatMessage(
  isSender: true,
  text: 'Hello!',
  chatMedia: ChatMedia(
    url: '…',
    mediaType: MediaType.imageMediaType(),
  ),
);
```

Includes `toMap()`, `toJson()`, `fromMap()`, `fromJson()`, `copyWith()`, and proper `==`/`hashCode`.

### `ChatMedia`

Holds a `url`/path and `MediaType` (image, audio, video).

---

## 🛠️ Next Milestones

- Video recording support
- Captions on images & videos
- Reactions & threads

---

## ⭐ Found This Useful?

Please give us a star on GitHub & share with your friends!

[Issues & Feedback](https://github.com/MOUKZ/chat_package/issues)
