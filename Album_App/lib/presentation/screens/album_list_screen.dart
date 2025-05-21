import 'package:album_app/presentation/blocs/album_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_bloc.dart';
import '../blocs/album_state.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            return ListView.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                final album = state.albums[index];
                return ListTile(
                  title: Text(album.title),
                  // Optional: Display userId
                  // subtitle: Text('User ID: ${album.userId}'),
                  onTap: () {
                    context.go('/album/${album.id}');
                    context.read<AlbumBloc>().add(FetchPhotos(album.id));
                  },
                );
              },
            );
          } else if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
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