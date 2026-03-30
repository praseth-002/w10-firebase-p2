import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    'week-8-practice-986c9-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  List<Artist>? _cachedArtist;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (_cachedArtist != null && forceFetch == false) {
      return _cachedArtist!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      _cachedArtist = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}

  @override
  Future<List<Comment>> fetchComments(String artistId) async {
    Uri uri = Uri.https(
      'week-8-practice-986c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (response.body == 'null') return [];
      Map<String, dynamic> json2 = json.decode(response.body);
      List<Comment> result = [];
      for (final entry in json2.entries) {
        result.add(CommentDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> postComment(String artistId, String text) async {
    Uri uri = Uri.https(
      'week-8-practice-986c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final response = await http.post(
      uri,
      body: json.encode(CommentDto.toJson(text)),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return Comment(id: responseJson['name'], text: text);
    } else {
      throw Exception('Failed to post comment');
    }
  }
}
