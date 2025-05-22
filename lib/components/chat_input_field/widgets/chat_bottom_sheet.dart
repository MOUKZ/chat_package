import 'package:flutter/material.dart';

/// A bottom sheet presenting image attachment options.
///
/// Displays three tappable options:
/// 1. Capture a new photo via camera
/// 2. Pick an existing image from the gallery
/// 3. Cancel and dismiss the sheet
///
/// All texts, icons, and styles are customizable.
class ChatBottomSheet extends StatelessWidget {
  /// Called when the user taps “From Camera”.
  final VoidCallback onCameraTap;

  /// Called when the user taps “From Gallery”.
  final VoidCallback onGalleryTap;

  /// Label for the “From Camera” option.
  final String cameraText;

  /// Icon for the “From Camera” option.
  final Icon? cameraIcon;

  /// Label for the “From Gallery” option.
  final String galleryText;

  /// Icon for the “From Gallery” option.
  final Icon? galleryIcon;

  /// Label for the “Cancel” option.
  final String cancelText;

  /// Icon for the “Cancel” option.
  final Icon? cancelIcon;

  /// Text style applied to all option labels.
  final TextStyle? textStyle;

  /// Creates a chat attachment bottom sheet.
  ///
  /// [onCameraTap] and [onGalleryTap] must not be null.
  /// [cameraText], [galleryText], and [cancelText] default to
  /// "From Camera", "From Gallery", and "Cancel" respectively.
  const ChatBottomSheet({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.cameraText = 'From Camera',
    this.galleryText = 'From Gallery',
    this.cancelText = 'Cancel',
    this.cameraIcon,
    this.galleryIcon,
    this.cancelIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          _buildOption(
            context: context,
            icon: cameraIcon ?? const Icon(Icons.camera_alt),
            label: cameraText,
            onTap: onCameraTap,
          ),
          _buildOption(
            context: context,
            icon: galleryIcon ?? const Icon(Icons.photo_library),
            label: galleryText,
            onTap: onGalleryTap,
          ),
          _buildOption(
            context: context,
            icon: cancelIcon ?? const Icon(Icons.close),
            label: cancelText,
            onTap: () => Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }

  /// Helper to build each list tile option.
  Widget _buildOption({
    required BuildContext context,
    required Icon icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(label, style: textStyle),
      onTap: onTap,
    );
  }
}
