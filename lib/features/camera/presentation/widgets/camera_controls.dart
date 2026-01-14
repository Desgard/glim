import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final FlashMode flashMode;
  final bool isTakingPicture;
  final VoidCallback onCapture;
  final VoidCallback onToggleFlash;

  const CameraControls({
    super.key,
    required this.flashMode,
    required this.isTakingPicture,
    required this.onCapture,
    required this.onToggleFlash,
  });

  IconData get _flashIcon {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flash toggle
          _ControlButton(
            icon: _flashIcon,
            onPressed: onToggleFlash,
          ),

          // Capture button
          _CaptureButton(
            onPressed: onCapture,
            isLoading: isTakingPicture,
          ),

          // Placeholder for balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 28,
      color: Colors.white,
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _CaptureButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
