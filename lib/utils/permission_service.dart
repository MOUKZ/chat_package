import 'package:permission_handler/permission_handler.dart';

/// Centralized permission handling for the chat package.
///
/// Wraps [permission_handler] so the rest of the package never deals with
/// platform/version specifics (e.g. Android 13+ photo permission vs legacy
/// storage). Each method requests the relevant permission and returns whether
/// it was granted, opening the app settings when a permission is permanently
/// denied.
class PermissionService {
  const PermissionService();

  /// Requests microphone access (needed to record voice notes).
  Future<bool> requestMicrophone() => _request(Permission.microphone);

  /// Requests camera access (needed for the in-app camera).
  Future<bool> requestCamera() => _request(Permission.camera);

  /// Requests access to the photo/gallery library.
  ///
  /// On Android 13+ this maps to the granular `photos` permission; older
  /// Android versions and iOS fall back to the appropriate equivalent handled
  /// by [permission_handler].
  Future<bool> requestGallery() async {
    if (await _request(Permission.photos)) return true;
    // Fallback for older Android versions that still use storage.
    return _request(Permission.storage);
  }

  Future<bool> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return status.isGranted || status.isLimited;
  }
}
