import 'package:flutter/foundation.dart';
import '../models/song.dart';

class PlayerProvider extends ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;
  double _progress = 0.0;
  bool _isShuffle = false;
  bool _isRepeat = false;
  List<Song> _queue = [];
  int _currentIndex = 0;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  List<Song> get queue => _queue;
  bool get hasCurrentSong => _currentSong != null;

  String get elapsedTimeString {
    if (_currentSong == null) return '00:00';
    final total = _currentSong!.duration.inSeconds;
    final elapsed = (total * _progress).round();
    final m = (elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void playSong(Song song, {List<Song>? queue}) {
    _queue = queue ?? [song];
    _currentIndex = _queue.indexWhere((s) => s.id == song.id);
    if (_currentIndex < 0) {
      _queue = [song, ..._queue];
      _currentIndex = 0;
    }
    _currentSong = song;
    _isPlaying = true;
    _progress = 0.0;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_currentSong == null) return;
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seekTo(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty) return;
    if (_isShuffle) {
      final random = DateTime.now().millisecondsSinceEpoch % _queue.length;
      _currentIndex = random;
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    _currentSong = _queue[_currentIndex];
    _isPlaying = true;
    _progress = 0.0;
    notifyListeners();
  }

  void previous() {
    if (_queue.isEmpty) return;
    if (_progress > 0.05) {
      _progress = 0.0;
    } else {
      _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
      _currentSong = _queue[_currentIndex];
      _progress = 0.0;
    }
    _isPlaying = true;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }
}
