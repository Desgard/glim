import 'package:flutter/material.dart';

import '../../models/focal_length_model.dart';

class FocalLengthSelector extends StatelessWidget {
  final FocalLength selectedFocalLength;
  final ValueChanged<FocalLength> onFocalLengthChanged;

  const FocalLengthSelector({
    super.key,
    required this.selectedFocalLength,
    required this.onFocalLengthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: FocalLengths.all.map((focalLength) {
          final isSelected = focalLength.mm == selectedFocalLength.mm;
          return _FocalLengthButton(
            focalLength: focalLength,
            isSelected: isSelected,
            onTap: () => onFocalLengthChanged(focalLength),
          );
        }).toList(),
      ),
    );
  }
}

class _FocalLengthButton extends StatelessWidget {
  final FocalLength focalLength;
  final bool isSelected;
  final VoidCallback onTap;

  const _FocalLengthButton({
    required this.focalLength,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.amber : Colors.transparent,
        ),
        child: Center(
          child: Text(
            focalLength.name,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
