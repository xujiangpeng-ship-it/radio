import 'package:flutter/material.dart';
import '../models/station.dart';

class StationListWidget extends StatelessWidget {
  final List<Station> stations;

  const StationListWidget({
    super.key,
    required this.stations,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                station.country.substring(0, 2).toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(station.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${station.country} • ${station.genre ?? "Unknown"}'),
            trailing: Icon(
              Icons.play_circle_fill,
              color: Colors.blue,
              size: 32,
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
