import 'package:just_audio/just_audio.dart';
import '../models/station.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Station? _currentStation;
  bool _isPlaying = false;

  Station? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Future<void> play(Station station) async {
    try {
      _currentStation = station;
      
      await _audioPlayer.setUrl(station.streamUrl ?? station.url);
      await _audioPlayer.play();
      
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Failed to play station: $e');
      _isPlaying = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentStation = null;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      if (_currentStation != null) {
        await play(_currentStation!);
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
