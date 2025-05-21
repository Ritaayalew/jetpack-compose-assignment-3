import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/albums_use_case.dart';
import '../../domain/usecase/photos_use_case.dart';

import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumsUseCase fetchAlbumsUseCase;
  final PhotosUseCase fetchPhotosUseCase;

  AlbumBloc({
    required this.fetchAlbumsUseCase,
    required this.fetchPhotosUseCase,
  }) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchPhotos>(_onFetchPhotos);
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await fetchAlbumsUseCase.call();
      emit(AlbumLoaded(albums: albums));
    } catch (e) {
      emit(AlbumError(message: e.toString()));
    }
  }

  Future<void> _onFetchPhotos(FetchPhotos event, Emitter<AlbumState> emit) async {
    emit(PhotoLoading());
    try {
      final photos = await fetchPhotosUseCase.call(event.albumId);
      emit(PhotoLoaded(photos: photos));
    } catch (e) {
      emit(PhotoError(message: e.toString()));
    }
  }
}