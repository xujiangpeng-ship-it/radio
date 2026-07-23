import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/station.dart';

final stationsProvider = StateNotifierProvider<StationsNotifier, List<Station>>((ref) {
  return StationsNotifier(ref);
});

class StationsNotifier extends StateNotifier<List<Station>> {
  StationsNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> load() async {
    state = [];
    try {
      final apiService = ref.read(apiServiceProvider);
      final stations = await apiService.getStations();
      state = stations;
    } catch (e) {
      print('Failed to load stations: $e');
    }
  }
}
