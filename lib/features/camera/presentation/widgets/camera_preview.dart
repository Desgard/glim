import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/filter_model.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final PhotoFilter? filter;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // Use camera's actual aspect ratio (inverted for portrait mode)
    final cameraAspectRatio = 1 / controller.value.aspectRatio;

    Widget preview = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: cameraAspectRatio,
        child: CameraPreview(controller),
      ),
    );

    if (filter != null) {
      preview = filter!.apply(preview);
    }

    return preview;
  }
}
