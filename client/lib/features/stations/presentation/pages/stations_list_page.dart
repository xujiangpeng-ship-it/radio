import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class StationsListPage extends ConsumerWidget {
  final String? country;

  const StationsListPage({super.key, this.country});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country ?? '全部电台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildStationsList(context),
    );
  }

  Widget _buildStationsList(BuildContext context) {
    // Simulated station list - in production, fetch from API
    final stations = List.generate(
      20,
      (index) => {
        'id': 'station_$index',
        'name': 'Radio Station ${index + 1}',
        'country': country ?? ['中国', '日本', '美国', '英国'][index % 4],
        'language': index % 2 == 0 ? '中文' : 'English',
        'genre': ['流行', '古典', '爵士', '摇滚'][index % 4],
      },
    );

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
          return _StationCard(station: station);
        },
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  final Map<String, dynamic> station;

  const _StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.radio, color: AppTheme.primaryColor),
        ),
        title: Text(
          station['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${station['country']} | ${station['language']} | ${station['genre']}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {},
        ),
        onTap: () {},
      ),
    );
  }
}
