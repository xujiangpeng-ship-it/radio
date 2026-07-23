# Script to properly set up Flutter project with full Android build system

# This script will be run ONCE after installing Flutter SDK
# It initializes the Android/iOS build infrastructure

param([string]$ProjectPath = "client")

Write-Host "Creating Flutter project in $ProjectPath..."

cd $ProjectPath

# Initialize Flutter project with minimum setup
flutter create . --project-name global_broadcast_app

# Now reapply our pubspec.yaml with correct dependencies
Set-Content -Path "pubspec.yaml" -Value @"
name: global_broadcast_app
description: A global radio broadcast app with real-time streaming, personalized recommendations, and multi-language support.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.6.1

  # Audio Playback
  just_audio: ^0.9.40
  audio_service: ^0.18.15
  chewie: ^1.8.5

  # Network & API
  dio: ^5.7.0

  # UI Components
  cached_network_image: ^3.4.1
  google_fonts: ^6.2.1

  # Storage
  shared_preferences: ^2.3.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
"@

# Update main.dart
$mainDart = @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../providers/stations_provider.dart';
import '../services/audio_player_service.dart';
import '../pages/stations_page.dart';

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
      home: const StationsPage(),
    );
  }
}
'@
Set-Content -Path "../lib/main.dart" -Value $mainDart

Write-Host "Flutter project initialized successfully!"
Write-Host "Next steps:"
Write-Host "  cd $ProjectPath"
Write-Host "  flutter pub get"
Write-Host "  flutter build apk --debug"
