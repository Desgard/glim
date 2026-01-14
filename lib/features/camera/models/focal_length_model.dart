/// Focal length options with zoom level mapping
class FocalLength {
  final String name;
  final int mm;
  final double zoomLevel;

  const FocalLength({
    required this.name,
    required this.mm,
    required this.zoomLevel,
  });
}

/// Predefined focal lengths
class FocalLengths {
  static const f28mm = FocalLength(
    name: '28',
    mm: 28,
    zoomLevel: 1.0,
  );

  static const f35mm = FocalLength(
    name: '35',
    mm: 35,
    zoomLevel: 1.25,
  );

  static const f50mm = FocalLength(
    name: '50',
    mm: 50,
    zoomLevel: 1.8,
  );

  static const f85mm = FocalLength(
    name: '85',
    mm: 85,
    zoomLevel: 3.0,
  );

  static const List<FocalLength> all = [
    f28mm,
    f35mm,
    f50mm,
    f85mm,
  ];

  static const FocalLength defaultFocalLength = f35mm;
}
