import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class DeezerService {
  DeezerService._();

  static const String _base = 'https://api.deezer.com';

  // ── Search tracks ──────────────────────────────────────────────────
  static Future<List<Song>> search(String query) async {
    try {
      final uri = Uri.parse(
          '$_base/search?q=${Uri.encodeComponent(query)}&limit=20');
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final List tracks = data['data'] ?? [];

      return tracks.map((t) => _fromJson(t)).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Get chart / trending ───────────────────────────────────────────
  static Future<List<Song>> getChart() async {
    try {
      final uri = Uri.parse('$_base/chart/0/tracks?limit=20');
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final List tracks = data['data'] ?? [];

      return tracks.map((t) => _fromJson(t)).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Map JSON → Song ────────────────────────────────────────────────
  static Song _fromJson(Map<String, dynamic> t) {
    return Song(
      id: t['id'].toString(),
      title: t['title'] ?? 'Unknown',
      artist: t['artist']?['name'] ?? 'Unknown Artist',
      album: t['album']?['title'] ?? 'Unknown Album',
      coverUrl: t['album']?['cover_big'] ??
          'https://picsum.photos/seed/${t['id']}/500/500',
      audioUrl: t['preview'], // 30 sec free preview
      duration: Duration(seconds: t['duration'] ?? 0),
      mood: 'Trending',
    );
  }
}
