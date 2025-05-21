import 'package:album_app/presentation/blocs/album_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/album_bloc.dart';
import '../blocs/album_state.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album $albumId Details')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotoLoaded) {
            return ListView.builder(
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          photo.thumbnailUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text('Title: ${photo.title}'),
                        Text('ID: ${photo.id}'),
                        Text('Album ID: ${photo.albumId}'),
                        Text('URL: ${photo.url}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PhotoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<AlbumBloc>().add(FetchPhotos(albumId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No photos available'));
        },
      ),
    );
  }
}