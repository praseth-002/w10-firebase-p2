import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'week-8-practice-986c9-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (_cachedSongs != null && forceFetch == false) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _cachedSongs = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song> likeSong(Song song) async {
    Uri songUri = Uri.https(
      'week-8-practice-986c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/${song.id}.json',
    );
    final response = await http.patch(
      songUri,
      body: json.encode({SongDto.likeKey: song.like + 1}),
    );
    if (response.statusCode == 200) {
      return Song(
        id: song.id,
        title: song.title,
        artistId: song.artistId,
        duration: song.duration,
        imageUrl: song.imageUrl,
        like: song.like + 1,
      );
    } else {
      throw Exception('Failed to like song');
    }
  }
}
