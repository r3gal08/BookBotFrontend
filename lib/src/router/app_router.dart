import 'package:auto_route/auto_route.dart';
import 'package:ollama_flutter_app/src/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  AppRouter();

  // TODO: We will want to make our "camera" page here and route similar to this.
  @override
  List<AutoRoute> get routes => [
        // HOME PAGE
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        // CHAT PAGE
        AutoRoute(
          page: ChatRoute.page,
        ),
        // SETTINGS PAGE
        AutoRoute(
          page: SettingsRoute.page,
        ),
      ];
}
