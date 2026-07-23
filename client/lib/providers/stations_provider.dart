import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/station.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final stationsProvider = StateNotifierProvider<StationsNotifier, List<Station>>((ref) {
  final notifier = StationsNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class StationsNotifier extends StateNotifier<List<Station>> {
  StationsNotifier(this.ref) : super([]) {
    loadStations();
  }

  final Ref ref;
  bool _isLoading = false;
  String? _error;

  Future<void> loadStations() async {
    if (_isLoading) return;
    _isLoading = true;
    
    try {
      final apiService = ref.read(apiServiceProvider);
      state = await apiService.getStations();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Failed to load stations: $_error');
    } finally {
      _isLoading = false;
    }
  }

  void refresh() {
    loadStations();
  }

  void dispose() {
    _isLoading = false;
  }
}
