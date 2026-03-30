import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w10firebase/data/repositories/artist/artist_repository.dart';
import 'package:w10firebase/data/repositories/songs/song_repository.dart';
import 'package:w10firebase/model/artist/artist.dart';
import 'package:w10firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:w10firebase/ui/screens/artist/widgets/artist_content.dart';

class ArtistScreen extends StatelessWidget {
  final Artist artist;

  const ArtistScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(
        artist: artist,
        artistRepository: context.read<ArtistRepository>(),
        songRepository: context.read<SongRepository>(),
      ),
      child: ArtistContent(),
    );
  }
}