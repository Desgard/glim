import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/permission_utils.dart';
import '../../providers/camera_provider.dart';
import '../widgets/camera_controls.dart';
import '../widgets/camera_preview.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraState = ref.read(cameraProvider);
    if (cameraState.controller == null ||
        !cameraState.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraState.controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final hasPermission = await PermissionUtils.requestCameraPermission();
    if (!hasPermission) {
      ref.read(cameraProvider.notifier).setPermissionDenied();
      return;
    }
    await ref.read(cameraProvider.notifier).initialize();
  }

  Future<void> _onCapture() async {
    final file = await ref.read(cameraProvider.notifier).takePicture();
    if (file != null && mounted) {
      // TODO: Navigate to preview/edit screen with the captured image
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo saved: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildBody(cameraState),
      ),
    );
  }

  Widget _buildBody(CameraState cameraState) {
    switch (cameraState.status) {
      case CameraStatus.uninitialized:
      case CameraStatus.initializing:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );

      case CameraStatus.permissionDenied:
        return _buildPermissionDenied();

      case CameraStatus.error:
        return _buildError(cameraState.errorMessage);

      case CameraStatus.ready:
        return _buildCameraView(cameraState);
    }
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            'Camera permission required',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await PermissionUtils.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message ?? 'An error occurred',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initializeCamera,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView(CameraState cameraState) {
    return Column(
      children: [
        Expanded(
          child: CameraPreviewWidget(
            controller: cameraState.controller!,
          ),
        ),
        CameraControls(
          flashMode: cameraState.flashMode,
          isRearCamera: cameraState.isRearCamera,
          isTakingPicture: cameraState.isTakingPicture,
          onCapture: _onCapture,
          onSwitchCamera: () {
            ref.read(cameraProvider.notifier).switchCamera();
          },
          onToggleFlash: () {
            ref.read(cameraProvider.notifier).toggleFlash();
          },
        ),
      ],
    );
  }
}
