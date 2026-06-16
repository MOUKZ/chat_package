import 'package:camera/camera.dart';
import 'package:chat_package/models/captured_media.dart';
import 'package:chat_package/screens/media_preview_page.dart';
import 'package:flutter/material.dart';

/// In-app camera that captures a photo (tap) or a video (hold), routes through
/// [MediaPreviewPage] for an optional caption, and pops a [CapturedMedia] back
/// to its caller.
class CameraScreen extends StatefulWidget {
  /// Available cameras (from `availableCameras()`).
  final List<CameraDescription> cameras;

  /// Resolution used by the camera preview and capture.
  final ResolutionPreset resolutionPreset;

  const CameraScreen({
    super.key,
    required this.cameras,
    this.resolutionPreset = ResolutionPreset.high,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeFuture;
  bool _isRecording = false;
  bool _flashOn = false;
  int _selectedCamera = 0;
  double _flipTurns = 0;

  @override
  void initState() {
    super.initState();
    _setUpCamera(_selectedCamera);
  }

  void _setUpCamera(int index) {
    final controller = CameraController(
      widget.cameras[index],
      widget.resolutionPreset,
    );
    _cameraController = controller;
    _initializeFuture = controller.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;
    if (controller == null) return;
    setState(() => _flashOn = !_flashOn);
    await controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _flipCamera() async {
    if (widget.cameras.length < 2) return;
    final previous = _cameraController;
    _selectedCamera = (_selectedCamera + 1) % widget.cameras.length;
    setState(() => _flipTurns += 0.5);
    await previous?.dispose();
    _setUpCamera(_selectedCamera);
  }

  Future<void> _takePhoto() async {
    final controller = _cameraController;
    if (controller == null || _isRecording) return;
    final file = await controller.takePicture();
    await _openPreview(file.path, isVideo: false);
  }

  Future<void> _startVideo() async {
    final controller = _cameraController;
    if (controller == null) return;
    await controller.startVideoRecording();
    if (mounted) setState(() => _isRecording = true);
  }

  Future<void> _stopVideo() async {
    final controller = _cameraController;
    if (controller == null || !_isRecording) return;
    final file = await controller.stopVideoRecording();
    if (mounted) setState(() => _isRecording = false);
    await _openPreview(file.path, isVideo: true);
  }

  Future<void> _openPreview(String path, {required bool isVideo}) async {
    if (!mounted) return;
    final result = await Navigator.of(context).push<CapturedMedia>(
      MaterialPageRoute(
        builder: (_) => MediaPreviewPage(path: path, isVideo: isVideo),
      ),
    );
    // Bubble a confirmed capture up to the caller; stay on camera otherwise.
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    controller != null &&
                    controller.value.isInitialized) {
                  return CameraPreview(controller);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleFlash,
                      ),
                      GestureDetector(
                        onTap: _takePhoto,
                        onLongPress: _startVideo,
                        onLongPressUp: _stopVideo,
                        child: Icon(
                          _isRecording
                              ? Icons.radio_button_on
                              : Icons.panorama_fish_eye,
                          color: _isRecording ? Colors.red : Colors.white,
                          size: _isRecording ? 80 : 70,
                        ),
                      ),
                      IconButton(
                        icon: AnimatedRotation(
                          turns: _flipTurns,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onPressed: _flipCamera,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hold for video, tap for photo',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
