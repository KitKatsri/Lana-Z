class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String? audioUrl;
  final Duration duration;
  final String mood;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    this.audioUrl,
    required this.duration,
    required this.mood,
  });

  String get durationString {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class SongData {
  SongData._();

  static const List<Song> catalog = [
    Song(id: '1', title: 'Young and Beautiful', artist: 'Lana Del Rey', album: 'The Great Gatsby OST', coverUrl: 'https://picsum.photos/seed/ynb400/500/500', duration: Duration(minutes: 4, seconds: 10), mood: 'Cinematic'),
    Song(id: '2', title: 'Video Games', artist: 'Lana Del Rey', album: 'Born to Die', coverUrl: 'https://picsum.photos/seed/vg400/500/500', duration: Duration(minutes: 4, seconds: 39), mood: 'Dreamy'),
    Song(id: '3', title: 'Summertime Sadness', artist: 'Lana Del Rey', album: 'Born to Die', coverUrl: 'https://picsum.photos/seed/sts400/500/500', duration: Duration(minutes: 4, seconds: 25), mood: 'Nostalgic'),
    Song(id: '4', title: 'Blue Jeans', artist: 'Lana Del Rey', album: 'Born to Die', coverUrl: 'https://picsum.photos/seed/bj400/500/500', duration: Duration(minutes: 3, seconds: 34), mood: 'Vintage'),
    Song(id: '5', title: 'Dark Paradise', artist: 'Lana Del Rey', album: 'Born to Die', coverUrl: 'https://picsum.photos/seed/dp400/500/500', duration: Duration(minutes: 3, seconds: 43), mood: 'Melancholic'),
    Song(id: '6', title: 'Ride', artist: 'Lana Del Rey', album: 'Born to Die: Paradise Edition', coverUrl: 'https://picsum.photos/seed/rd400/500/500', duration: Duration(minutes: 5, seconds: 9), mood: 'Cinematic'),
    Song(id: '7', title: 'National Anthem', artist: 'Lana Del Rey', album: 'Born to Die', coverUrl: 'https://picsum.photos/seed/na400/500/500', duration: Duration(minutes: 3, seconds: 51), mood: 'Glamorous'),
    Song(id: '8', title: 'Ultraviolence', artist: 'Lana Del Rey', album: 'Ultraviolence', coverUrl: 'https://picsum.photos/seed/uv400/500/500', duration: Duration(minutes: 4, seconds: 13), mood: 'Dark'),
    Song(id: '9', title: 'High by the Beach', artist: 'Lana Del Rey', album: 'Honeymoon', coverUrl: 'https://picsum.photos/seed/hbb400/500/500', duration: Duration(minutes: 4, seconds: 1), mood: 'Dreamy'),
    Song(id: '10', title: 'Mariners Apartment Complex', artist: 'Lana Del Rey', album: 'Norman Fucking Rockwell!', coverUrl: 'https://picsum.photos/seed/mac400/500/500', duration: Duration(minutes: 4, seconds: 27), mood: 'Nostalgic'),
    Song(id: '11', title: 'Doin Time', artist: 'Lana Del Rey', album: 'Norman Fucking Rockwell!', coverUrl: 'https://picsum.photos/seed/dt400/500/500', duration: Duration(minutes: 4, seconds: 5), mood: 'Vintage'),
    Song(id: '12', title: 'Venice Bitch', artist: 'Lana Del Rey', album: 'Norman Fucking Rockwell!', coverUrl: 'https://picsum.photos/seed/vb400/500/500', duration: Duration(minutes: 9, seconds: 36), mood: 'Dreamy'),
  ];

  static List<Song> get featured => catalog.sublist(0, 5);

  static const List<String> moods = [
    'All', 'Cinematic', 'Dreamy', 'Nostalgic',
    'Vintage', 'Dark', 'Glamorous', 'Melancholic',
  ];

  static List<Song> byMood(String mood) {
    if (mood == 'All') return catalog;
    return catalog.where((s) => s.mood == mood).toList();
  }
}
