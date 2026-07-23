import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stations_provider.dart';
import '../widgets/station_list_widget.dart';

class StationsPage extends ConsumerWidget {
  final bool showSearch;
  final bool showFavorites;

  const StationsPage({
    super.key,
    this.showSearch = true,
    this.showFavorites = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);
    final loading = stations.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(showFavorites ? '我的收藏' : '全球电台'),
        actions: showSearch 
          ? [IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            )]
          : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.radio,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            if (loading)
              const CircularProgressIndicator()
            else
              StationListWidget(stations: stations),
          ],
        ),
      ),
    );
  }
}
