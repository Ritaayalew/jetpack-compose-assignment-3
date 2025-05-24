import './data/repository/album_repository.dart';
import './domain/repository/album_repository_implementation.dart';
import './domain/usecase/albums_use_case.dart';
import './domain/usecase/photos_use_case.dart';
import './presentation/blocs/album_bloc.dart';
import './presentation/blocs/album_event.dart';
import './presentation/screens/album_detail_screen.dart';
import './presentation/screens/album_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListScreen(),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['id']!);
          return AlbumDetailScreen(albumId: albumId);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    print('Building MyApp at ${DateTime.now()} EAT');
    return Provider<AlbumRepository>(
      create: (_) {
        print('Creating AlbumRepositoryImplementation at ${DateTime.now()} EAT');
        try {
          return AlbumRepositoryImplementation();
        } catch (e) {
          print('Error creating AlbumRepositoryImplementation: $e');
          rethrow;
        }
      },
      dispose: (_, repo) {
        if (repo is AlbumRepositoryImplementation) {
          repo.dispose();
          print('Disposed AlbumRepositoryImplementation at ${DateTime.now()} EAT');
        }
      },
      child: Builder(
        builder: (providerContext) {
          print('Inside Builder with providerContext at ${DateTime.now()} EAT');
          return BlocProvider(
            create: (blocContext) {
              print('Creating AlbumBloc with blocContext at ${DateTime.now()} EAT');
              final repository = Provider.of<AlbumRepository>(providerContext, listen: false);
              if (repository == null) {
                print('Provider.of<AlbumRepository> returned null in blocContext');
                throw Exception('Provider returned null for AlbumRepository in blocContext');
              }
              print('Repository fetched successfully: $repository');
              try {
                final albumBloc = AlbumBloc(
                  fetchAlbumsUseCase: AlbumsUseCase(repository),
                  fetchPhotosUseCase: PhotosUseCase(repository),
                );
                print('AlbumBloc created successfully: $albumBloc');
                albumBloc.add(FetchAlbums());
                return albumBloc;
              } catch (e) {
                print('Error creating AlbumBloc: $e');
                rethrow;
              }
            },
            child: MaterialApp.router(
              title: 'Album App',
              theme: ThemeData(primarySwatch: Colors.blue),
              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}