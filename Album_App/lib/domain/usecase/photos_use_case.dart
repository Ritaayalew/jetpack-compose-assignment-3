import '../../data/models/photo.dart';
import '../../data/repository/album_repository.dart';

class PhotosUseCase {
  final AlbumRepository repository;

  PhotosUseCase(this.repository);

  Future<List<Photo>> call(int albumId) async {
    return await repository.fetchPhotos(albumId);
  }
}