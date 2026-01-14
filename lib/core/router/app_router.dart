import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/camera/presentation/screens/camera_screen.dart';

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
      // Add more routes as needed:
      // GoRoute(
      //   path: AppRoutes.gallery,
      //   name: 'gallery',
      //   builder: (context, state) => const GalleryScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.settings,
      //   name: 'settings',
      //   builder: (context, state) => const SettingsScreen(),
      // ),
      // GoRoute(
      //   path: '${AppRoutes.preview}/:photoId',
      //   name: 'preview',
      //   builder: (context, state) {
      //     final photoId = state.pathParameters['photoId']!;
      //     return PreviewScreen(photoId: photoId);
      //   },
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
