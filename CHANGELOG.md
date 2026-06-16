## 2.1.0

Major modernization, new features and bug fixes.

* **Upgraded** to Dart >= 3.0 / Flutter >= 3.16 and the latest major versions of
  all dependencies (`permission_handler`, `image_picker`, `just_audio`,
  `record`, `intl`, `camera`, `video_player`, `provider`, `photo_view`,
  `stop_watch_timer`).
* **Removed** the Freezed dependency: `MediaType` is now a plain enum
  (`MediaType.image` / `.audio` / `.video`).
* **New:** in-app camera now captures photos and videos and returns them into
  the chat with an optional caption.
* **New:** video messages render as a tappable thumbnail with full-screen
  playback (`handleVideoSelect` callback).
* **New customization:** `textDirection`, `containerBorderRadius`,
  `buttonRadius`, message width fractions, camera resolution, audio bit rate and
  image quality.
* **Fixed:** gallery used the camera permission instead of the photo permission.
* **Fixed:** leaked `AudioPlayer`, stream subscriptions and the recording timer;
  added `dispose`/`mounted` guards across async flows.
* **Fixed:** `textEditingController` is now actually used; removed the broken
  `TextTheme.bodyText1` usage and deprecated `withOpacity` calls.
* Removed dead/stub UI from the camera preview and added `analysis_options.yaml`
  (passes `flutter analyze` with no issues).

> **Breaking:** see the migration guide in the README.

## 1.0.0

* bug fixes.

## 1.0.1-beta

* bug fixes.

## 1.0.0-beta

* Add Support For Flutter 3.

## 0.0.7

* more documentation.

## 0.0.6

* textController bug fix.

## 0.0.5

* bug fix.

## 0.0.4

* adding disable input functionality.

## 0.0.3

* adding example and more functionality for handling record sliding.

## 0.0.2

* documenting the package and general improvements.

## 0.0.1

* initial release.