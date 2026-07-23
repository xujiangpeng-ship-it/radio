import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/station.dart';
import '../services/api_service.dart';
import '../services/audio_player_service.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ApiService _apiService = ApiService();
  List<Station> _stations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stations = await _apiService.getStations();
      
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _playStation(Station station) {
    final playerService = ref.read(audioPlayerServiceProvider);
    playerService.play(station);
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioPlayerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('全球广播'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadStations(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('加载失败: $_error', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadStations(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _stations.length,
                itemBuilder: (context, index) {
                  final station = _stations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getGenreColor(station.genre),
                        child: Text(
                          station.country.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        station.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${station.country} • ${station.language}'),
                      trailing: IconButton(
                        icon: Icon(
                          audioPlayer.currentStation?.id == station.id && audioPlayer.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.blue,
                          size: 40,
                        ),
                        onPressed: () => _playStation(station),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Bottom player bar
          if (audioPlayer.currentStation != null)
            _buildPlayerBar(audioPlayer),
        ],
      ),
    );
  }

  Widget _buildPlayerBar(AudioPlayerService player) {
    final station = player.currentStation!;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${station.country} • ${station.genre ?? "Unknown"}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                player.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => player.togglePlayPause(),
            ),
            IconButton(
              icon: const Icon(Icons.stop, color: Colors.white, size: 30),
              onPressed: () => player.stop(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGenreColor(String? genre) {
    switch (genre?.toLowerCase()) {
      case 'news':
        return Colors.red;
      case 'music':
        return Colors.purple;
      case 'talk':
        return Colors.orange;
      case 'classical':
        return Colors.indigo;
      case 'general':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}
