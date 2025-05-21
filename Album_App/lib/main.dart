import 'package:album_app/data/repository/album_repository.dart';
import 'package:album_app/domain/repository/album_repository_implementation.dart';
import 'package:album_app/domain/usecase/albums_use_case.dart';
import 'package:album_app/domain/usecase/photos_use_case.dart';
import 'package:album_app/presentation/blocs/album_bloc.dart';
import 'package:album_app/presentation/blocs/album_event.dart';
import 'package:album_app/presentation/screens/album_detail_screen.dart';
import 'package:album_app/presentation/screens/album_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return RepositoryProvider(
      create: (context) => AlbumRepositoryImplementation(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AlbumBloc(
              fetchAlbumsUseCase: AlbumsUseCase(
                RepositoryProvider.of<AlbumRepository>(context),
              ),
              fetchPhotosUseCase: PhotosUseCase(
                RepositoryProvider.of<AlbumRepository>(context),
              ),
            )..add(FetchAlbums()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Album App',
          theme: ThemeData(primarySwatch: Colors.blue),
          routerConfig: _router,
        ),
      ),
    );
  }
}