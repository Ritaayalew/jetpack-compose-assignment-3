import 'package:album_app/data/models/album.dart';
import 'package:album_app/data/models/photo.dart';
import 'package:equatable/equatable.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  const AlbumLoaded({required this.albums});

  @override
  List<Object?> get props => [albums];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PhotoLoading extends AlbumState {}

class PhotoLoaded extends AlbumState {
  final List<Photo> photos;

  const PhotoLoaded({required this.photos});

  @override
  List<Object?> get props => [photos];
}

class PhotoError extends AlbumState {
  final String message;

  const PhotoError({required this.message});

  @override
  List<Object?> get props => [message];
}