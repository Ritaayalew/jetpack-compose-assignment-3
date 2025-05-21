import 'package:album_app/data/models/photo.dart';
import 'package:album_app/data/repository/album_repository.dart';

class PhotosUseCase {
  final AlbumRepository repository;

  PhotosUseCase(this.repository);

  Future<List<Photo>> call(int albumId) async {
    return await repository.fetchPhotos(albumId);
  }
}