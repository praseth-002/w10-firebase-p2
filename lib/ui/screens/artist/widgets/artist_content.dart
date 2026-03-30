import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w10firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:w10firebase/ui/theme/theme.dart';
import 'package:w10firebase/ui/utils/async_value.dart';
import 'package:w10firebase/ui/widgets/song/song_tile.dart';

class ArtistContent extends StatefulWidget {
  const ArtistContent({super.key});

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArtistViewModel vm = context.watch<ArtistViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(vm.artist.name)),
      body: Column(
        children: [
          // Songs section
          Text("Songs", style: AppTextStyles.heading),
          vm.songsValue.state == AsyncValueState.loading
              ? CircularProgressIndicator()
              : vm.songsValue.data!.isEmpty
                  ? Text("No songs")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: vm.songsValue.data!.length,
                      itemBuilder: (context, index) =>
                          SongTile(song: vm.songsValue.data![index]),
                    ),

          // Comments section
          Text("Comments", style: AppTextStyles.heading),
          vm.commentsValue.state == AsyncValueState.loading
              ? CircularProgressIndicator()
              : vm.commentsValue.data!.isEmpty
                  ? Text("No comments yet")
                  : Expanded(
                      child: ListView.builder(
                        itemCount: vm.commentsValue.data!.length,
                        itemBuilder: (context, index) =>
                            ListTile(title: Text(vm.commentsValue.data![index].text)),
                      ),
                    ),
        ],
      ),

      // Comment input at the bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: "Write a comment..."),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                vm.addComment(_controller.text.trim());
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}