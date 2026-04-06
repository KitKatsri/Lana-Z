import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/deezer_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Song? _currentSong;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  List<Song> _queue = [];
  List<Song> _searchResults = [];
  List<Song> _chartSongs = [];
  int _currentIndex = 0;
  double _progress = 0.0;
  String _errorMessage = '';

  // ── Getters ───────────────────────────────────────────────────────
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  List<Song> get queue => _queue;
  List<Song> get searchResults => _searchResults;
  List<Song> get chartSongs => _chartSongs;
  double get progress => _progress;
  bool get hasCurrentSong => _currentSong != null;
  String get errorMessage => _errorMessage;

  String get elapsedTimeString {
    if (_currentSong == null) return '00:00';
    final total = _currentSong!.duration.inSeconds;
    final elapsed = (total * _progress).round();
    final m = (elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  AudioProvider() {
    _initPlayer();
    loadChart();
  }

  void _initPlayer() {
    // Listen to position changes
    _player.positionStream.listen((position) {
      final duration = _player.duration;
      if (duration != null && duration.inSeconds > 0) {
        _progress = position.inSeconds / duration.inSeconds;
        notifyListeners();
      }
    });

    // Listen to player state
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        next();
      }
      notifyListeners();
    });
  }

  // ── Load chart ────────────────────────────────────────────────────
  Future<void> loadChart() async {
    _chartSongs = await DeezerService.getChart();
    notifyListeners();
  }

  // ── Search ────────────────────────────────────────────────────────
  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    _searchResults = await DeezerService.search(query);
    _isLoading = false;
    notifyListeners();
  }

  // ── Play a song ───────────────────────────────────────────────────
  Future<void> playSong(Song song, {List<Song>? queue}) async {
    _queue = queue ?? [song];
    _currentIndex = _queue.indexWhere((s) => s.id == song.id);
    if (_currentIndex < 0) {
      _queue = [song, ..._queue];
      _currentIndex = 0;
    }

    _currentSong = song;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (song.audioUrl != null && song.audioUrl!.isNotEmpty) {
        await _player.setUrl(song.audioUrl!);
        await _player.play();
      } else {
        _errorMessage = 'No preview available';
      }
    } catch (e) {
      _errorMessage = 'Could not play song';
    }

    _isLoading = false;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void seekTo(double value) {
    final duration = _player.duration;
    if (duration != null) {
      final position = Duration(
          seconds: (duration.inSeconds * value).round());
      _player.seek(position);
    }
    _progress = value;
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty) return;
    if (_isShuffle) {
      final random =
          DateTime.now().millisecondsSinceEpoch % _queue.length;
      _currentIndex = random;
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    playSong(_queue[_currentIndex], queue: _queue);
  }

  void previous() {
    if (_queue.isEmpty) return;
    if (_progress > 0.05) {
      seekTo(0.0);
    } else {
      _currentIndex =
          (_currentIndex - 1 + _queue.length) % _queue.length;
      playSong(_queue[_currentIndex], queue: _queue);
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    _player.setLoopMode(
        _isRepeat ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
