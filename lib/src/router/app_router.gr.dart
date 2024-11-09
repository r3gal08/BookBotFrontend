// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:camera/camera.dart' as _i8;
import 'package:flutter/material.dart' as _i7;
import 'package:ollama_flutter_app/src/features/camera_feature/presentation/pages/camera_page.dart'
    as _i1;
import 'package:ollama_flutter_app/src/features/camera_feature/presentation/pages/image_view_page.dart'
    as _i4;
import 'package:ollama_flutter_app/src/features/chat_feature/presentation/page/chat_page.dart'
    as _i2;
import 'package:ollama_flutter_app/src/features/home_feature/presentation/page/home_page.dart'
    as _i3;
import 'package:ollama_flutter_app/src/features/settings_feature/presentation/page/settings_page.dart'
    as _i5;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    CameraRoute.name: (routeData) {
      final args = routeData.argsAs<CameraRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CameraPage(
          key: args.key,
          cameras: args.cameras,
        ),
      );
    },
    ChatRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
      );
    },
    ImageViewRoute.name: (routeData) {
      final args = routeData.argsAs<ImageViewRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ImageViewPage(
          key: args.key,
          imagePath: args.imagePath,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SettingsPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.CameraPage]
class CameraRoute extends _i6.PageRouteInfo<CameraRouteArgs> {
  CameraRoute({
    _i7.Key? key,
    required List<_i8.CameraDescription> cameras,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          CameraRoute.name,
          args: CameraRouteArgs(
            key: key,
            cameras: cameras,
          ),
          initialChildren: children,
        );

  static const String name = 'CameraRoute';

  static const _i6.PageInfo<CameraRouteArgs> page =
      _i6.PageInfo<CameraRouteArgs>(name);
}

class CameraRouteArgs {
  const CameraRouteArgs({
    this.key,
    required this.cameras,
  });

  final _i7.Key? key;

  final List<_i8.CameraDescription> cameras;

  @override
  String toString() {
    return 'CameraRouteArgs{key: $key, cameras: $cameras}';
  }
}

/// generated route for
/// [_i2.ChatPage]
class ChatRoute extends _i6.PageRouteInfo<void> {
  const ChatRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ImageViewPage]
class ImageViewRoute extends _i6.PageRouteInfo<ImageViewRouteArgs> {
  ImageViewRoute({
    _i7.Key? key,
    required String imagePath,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          ImageViewRoute.name,
          args: ImageViewRouteArgs(
            key: key,
            imagePath: imagePath,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageViewRoute';

  static const _i6.PageInfo<ImageViewRouteArgs> page =
      _i6.PageInfo<ImageViewRouteArgs>(name);
}

class ImageViewRouteArgs {
  const ImageViewRouteArgs({
    this.key,
    required this.imagePath,
  });

  final _i7.Key? key;

  final String imagePath;

  @override
  String toString() {
    return 'ImageViewRouteArgs{key: $key, imagePath: $imagePath}';
  }
}

/// generated route for
/// [_i5.SettingsPage]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
