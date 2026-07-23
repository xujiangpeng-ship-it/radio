import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/stations/presentation/pages/stations_list_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/player/presentation/pages/player_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static const String home = '/';
  static const String stations = '/stations';
  static const String favorites = '/favorites';
  static const String player = '/player';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case stations:
        return MaterialPageRoute(
          builder: (_) => StationsListPage(country: settings.arguments as String?),
        );
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case player:
        return MaterialPageRoute(
          builder: (_) => PlayerPage(stationId: settings.arguments as String),
        );
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
