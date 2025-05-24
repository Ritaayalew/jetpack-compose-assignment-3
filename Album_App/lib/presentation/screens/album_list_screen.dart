import '../blocs/album_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_bloc.dart';
import '../blocs/album_state.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch FetchAlbums event when the screen is built
    context.read<AlbumBloc>().add(FetchAlbums());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        centerTitle: true, // Center the AppBar title
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            return ListView.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                final album = state.albums[index];
                return Center(
                  // Center the card horizontally
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // Constrain card width (90% of screen)
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4.0, // Subtle shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      child: InkWell(
                        // Make the card tappable
                        onTap: () {
                          context.go('/album/${album.id}');
                          context.read<AlbumBloc>().add(FetchPhotos(album.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                album.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Bold title
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Album ID: ${album.id}'),
                              // Optional: Uncomment to show userId
                              // Text('User ID: ${album.userId}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AlbumBloc>().add(FetchAlbums()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}