import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/filter_model.dart';

/// 目标裁切比例 3:2 (宽:高)，竖屏下为 2:3
const double kTargetAspectRatio = 2 / 3;

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(controller),
            CustomPaint(
              painter: _CropOverlayPainter(
                targetAspectRatio: kTargetAspectRatio,
                overlayColor: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );

    if (filter != null) {
      preview = filter!.apply(preview);
    }

    return preview;
  }
}

class _CropOverlayPainter extends CustomPainter {
  final double targetAspectRatio;
  final Color overlayColor;

  _CropOverlayPainter({
    required this.targetAspectRatio,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    // 计算目标裁切区域
    final double cropWidth;
    final double cropHeight;

    // 基于宽度计算目标高度
    final heightBasedOnWidth = size.width / targetAspectRatio;

    if (heightBasedOnWidth <= size.height) {
      // 宽度受限，使用全宽
      cropWidth = size.width;
      cropHeight = heightBasedOnWidth;
    } else {
      // 高度受限，使用全高
      cropHeight = size.height;
      cropWidth = size.height * targetAspectRatio;
    }

    // 居中裁切区域
    final left = (size.width - cropWidth) / 2;
    final top = (size.height - cropHeight) / 2;

    // 绘制遮罩（裁切区域外的部分）
    // 上方遮罩
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, top),
      paint,
    );
    // 下方遮罩
    canvas.drawRect(
      Rect.fromLTWH(0, top + cropHeight, size.width, size.height - top - cropHeight),
      paint,
    );
    // 左侧遮罩
    canvas.drawRect(
      Rect.fromLTWH(0, top, left, cropHeight),
      paint,
    );
    // 右侧遮罩
    canvas.drawRect(
      Rect.fromLTWH(left + cropWidth, top, size.width - left - cropWidth, cropHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return oldDelegate.targetAspectRatio != targetAspectRatio ||
        oldDelegate.overlayColor != overlayColor;
  }
}
