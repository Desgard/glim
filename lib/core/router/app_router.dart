import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/camera/presentation/screens/camera_screen.dart';
import '../../features/camera/presentation/screens/preview_screen.dart';

/// Route paths constants
abstract class AppRoutes {
  static const camera = '/';
  static const gallery = '/gallery';
  static const settings = '/settings';
  static const preview = '/preview';
}

/// GoRouter configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.camera,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.camera,
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: AppRoutes.preview,
        name: 'preview',
        builder: (context, state) {
          final params = state.extra as PreviewParams;
          return PreviewScreen(
            imagePath: params.imagePath,
            filter: params.filter,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
