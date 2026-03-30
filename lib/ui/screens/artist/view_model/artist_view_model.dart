import 'package:flutter/material.dart';
import 'package:w10firebase/data/repositories/artist/artist_repository.dart';
import 'package:w10firebase/data/repositories/songs/song_repository.dart';
import 'package:w10firebase/model/artist/artist.dart';
import 'package:w10firebase/model/comment/comment.dart';
import 'package:w10firebase/model/songs/song.dart';
import 'package:w10firebase/ui/utils/async_value.dart';

class ArtistViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final SongRepository songRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistViewModel({
    required this.artistRepository,
    required this.songRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() async {
    fetchData();
  }

  void fetchData() async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final results = await Future.wait([
        songRepository.fetchSongs(),
        artistRepository.fetchComments(artist.id),
      ]);

      List<Song> allSongs = results[0] as List<Song>;
      songsValue = AsyncValue.success(
        allSongs.where((s) => s.artistId == artist.id).toList(),
      );

      commentsValue = AsyncValue.success(results[1] as List<Comment>);
    } catch (e) {
      songsValue = AsyncValue.error(e);
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void addComment(String text) async {
    try {
      Comment newComment = await artistRepository.postComment(artist.id, text);
      List<Comment> current = commentsValue.data ?? [];
      commentsValue = AsyncValue.success([...current, newComment]);
      notifyListeners();
    } catch (e) {
      // silently fail for now
    }
  }
}