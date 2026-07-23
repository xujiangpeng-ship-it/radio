import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../providers/stations_provider.dart';
import '../services/audio_player_service.dart';
import '../pages/stations_page.dart';
import '../pages/favorites_page.dart';
import '../pages/player_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: ChangeNotifierProvider<AudioPlayerService>(
        create: (_) => AudioPlayerService(),
        child: const GlobalBroadcastApp(),
      ),
    ),
  );
}

class GlobalBroadcastApp extends StatelessWidget {
  const GlobalBroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '全球广播',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const StationsPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // TODO: Navigate to different pages
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: '电台',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '收藏',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
