import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stations_provider.dart';
import '../services/audio_player_service.dart';
import '../widgets/player_bar.dart';

class StationsPage extends ConsumerWidget {
  const StationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('全球电台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: stations.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stations.length,
                    itemBuilder: (context, index) {
                      final station = stations[index];
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${station.country} • ${station.language}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              if (station.description != null)
                                Text(
                                  station.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.play_circle_outline,
                              size: 32,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              final playerService = ref.read(audioPlayerServiceProvider);
                              playerService.play(station);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Player bar at bottom
          const PlayerBar(),
        ],
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
