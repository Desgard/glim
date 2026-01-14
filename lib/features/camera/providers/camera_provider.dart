import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/focal_length_model.dart';

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
  final FlashMode flashMode;
  final bool isTakingPicture;
  final FocalLength focalLength;
  final double minZoom;
  final double maxZoom;

  const CameraState({
    this.controller,
    this.status = CameraStatus.uninitialized,
    this.errorMessage,
    this.flashMode = FlashMode.off,
    this.isTakingPicture = false,
    this.focalLength = FocalLengths.defaultFocalLength,
    this.minZoom = 1.0,
    this.maxZoom = 1.0,
  });

  CameraState copyWith({
    CameraController? controller,
    CameraStatus? status,
    String? errorMessage,
    FlashMode? flashMode,
    bool? isTakingPicture,
    FocalLength? focalLength,
    double? minZoom,
    double? maxZoom,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      flashMode: flashMode ?? this.flashMode,
      isTakingPicture: isTakingPicture ?? this.isTakingPicture,
      focalLength: focalLength ?? this.focalLength,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
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

      // Only use back camera
      final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      await _initializeController(backCamera);
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

      // Get zoom range
      final minZoom = await controller.getMinZoomLevel();
      final maxZoom = await controller.getMaxZoomLevel();

      // Apply default focal length zoom
      final defaultZoom = state.focalLength.zoomLevel.clamp(minZoom, maxZoom);
      await controller.setZoomLevel(defaultZoom);

      state = state.copyWith(
        controller: controller,
        status: CameraStatus.ready,
        minZoom: minZoom,
        maxZoom: maxZoom,
      );
    } catch (e) {
      state = state.copyWith(
        status: CameraStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> setFocalLength(FocalLength focalLength) async {
    if (state.controller == null) return;

    final zoomLevel = focalLength.zoomLevel.clamp(state.minZoom, state.maxZoom);
    await state.controller!.setZoomLevel(zoomLevel);
    state = state.copyWith(focalLength: focalLength);
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
