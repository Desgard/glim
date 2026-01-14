import 'package:flutter/material.dart';

class PhotoFilter {
  final String id;
  final String name;
  final ColorFilter? colorFilter;
  final List<double>? colorMatrix;

  const PhotoFilter({
    required this.id,
    required this.name,
    this.colorFilter,
    this.colorMatrix,
  });

  /// Apply filter using ColorFiltered widget
  Widget apply(Widget child) {
    if (colorFilter != null) {
      return ColorFiltered(
        colorFilter: colorFilter!,
        child: child,
      );
    }
    if (colorMatrix != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(colorMatrix!),
        child: child,
      );
    }
    return child;
  }
}

/// Predefined filters
class PhotoFilters {
  static const original = PhotoFilter(
    id: 'original',
    name: '原片',
  );

  static final warm = PhotoFilter(
    id: 'warm',
    name: '暖阳',
    colorMatrix: [
      1.2, 0, 0, 0, 20,
      0, 1.1, 0, 0, 10,
      0, 0, 0.9, 0, 0,
      0, 0, 0, 1, 0,
    ],
  );

  static final cool = PhotoFilter(
    id: 'cool',
    name: '清冷',
    colorMatrix: [
      0.9, 0, 0, 0, 0,
      0, 1.0, 0, 0, 0,
      0, 0, 1.2, 0, 20,
      0, 0, 0, 1, 0,
    ],
  );

  static final vintage = PhotoFilter(
    id: 'vintage',
    name: '复古',
    colorMatrix: [
      0.9, 0.1, 0.1, 0, 0,
      0.1, 0.9, 0.1, 0, 0,
      0.1, 0.1, 0.7, 0, 0,
      0, 0, 0, 1, 0,
    ],
  );

  static final grayscale = PhotoFilter(
    id: 'grayscale',
    name: '黑白',
    colorMatrix: [
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0, 0, 0, 1, 0,
    ],
  );

  static final sepia = PhotoFilter(
    id: 'sepia',
    name: '怀旧',
    colorMatrix: [
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0, 0, 0, 1, 0,
    ],
  );

  static final vivid = PhotoFilter(
    id: 'vivid',
    name: 'F.Velvia',
    colorMatrix: [
      1.3, -0.1, -0.1, 0, 10,
      -0.1, 1.3, -0.1, 0, 10,
      -0.1, -0.1, 1.3, 0, 10,
      0, 0, 0, 1, 0,
    ],
  );

  static final fade = PhotoFilter(
    id: 'fade',
    name: 'Toari.Film',
    colorMatrix: [
      1.0, 0, 0, 0, 30,
      0, 1.0, 0, 0, 30,
      0, 0, 1.0, 0, 30,
      0, 0, 0, 0.9, 0,
    ],
  );

  static final film = PhotoFilter(
    id: 'film',
    name: '胶片',
    colorMatrix: [
      1.1, 0, 0, 0, -10,
      0, 1.05, 0.05, 0, 5,
      0.05, 0.1, 1.0, 0, 15,
      0, 0, 0, 1, 0,
    ],
  );

  static final List<PhotoFilter> all = [
    original,
    fade,
    vivid,
  ];
}
