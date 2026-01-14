import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CameraStatus {
  uninitialized,
  initializing,
  ready,
  error,
  permissionDenied,
}

class CameraState {
  final CameraController? controller;
  final CameraStatus status;
  final String? errorMessage;
  final bool isRearCamera;
  final FlashMode flashMode;
  final bool isTakingPicture;

  const CameraState({
    this.controller,
    this.status = CameraStatus.uninitialized,
    this.errorMessage,
    this.isRearCamera = true,
    this.flashMode = FlashMode.off,
    this.isTakingPicture = false,
  });

  CameraState copyWith({
    CameraController? controller,
    CameraStatus? status,
    String? errorMessage,
    bool? isRearCamera,
    FlashMode? flashMode,
    bool? isTakingPicture,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isRearCamera: isRearCamera ?? this.isRearCamera,
      flashMode: flashMode ?? this.flashMode,
      isTakingPicture: isTakingPicture ?? this.isTakingPicture,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(const CameraState());

  List<CameraDescription> _cameras = [];

  Future<void> initialize() async {
    state = state.copyWith(status: CameraStatus.initializing);

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        state = state.copyWith(
          status: CameraStatus.error,
          errorMessage: 'No cameras available',
        );
        return;
      }

      await _initializeController(_cameras.first);
    } catch (e) {
      state = state.copyWith(
        status: CameraStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _initializeController(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      await controller.setFlashMode(state.flashMode);

      state = state.copyWith(
        controller: controller,
        status: CameraStatus.ready,
        isRearCamera: camera.lensDirection == CameraLensDirection.back,
      );
    } catch (e) {
      state = state.copyWith(
        status: CameraStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    final currentDirection = state.isRearCamera
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection != currentDirection,
      orElse: () => _cameras.first,
    );

    await state.controller?.dispose();
    state = state.copyWith(status: CameraStatus.initializing);
    await _initializeController(newCamera);
  }

  Future<void> toggleFlash() async {
    if (state.controller == null) return;

    final modes = [FlashMode.off, FlashMode.auto, FlashMode.always];
    final currentIndex = modes.indexOf(state.flashMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];

    await state.controller!.setFlashMode(nextMode);
    state = state.copyWith(flashMode: nextMode);
  }

  Future<XFile?> takePicture() async {
    if (state.controller == null || state.isTakingPicture) return null;

    state = state.copyWith(isTakingPicture: true);

    try {
      final file = await state.controller!.takePicture();
      state = state.copyWith(isTakingPicture: false);
      return file;
    } catch (e) {
      state = state.copyWith(isTakingPicture: false);
      return null;
    }
  }

  void setPermissionDenied() {
    state = state.copyWith(status: CameraStatus.permissionDenied);
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>(
  (ref) => CameraNotifier(),
);
