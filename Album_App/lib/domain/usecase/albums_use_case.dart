import 'package:album_app/data/models/album.dart';
import 'package:album_app/data/repository/album_repository.dart';

class AlbumsUseCase {
  final AlbumRepository repository;

  AlbumsUseCase(this.repository);

  Future<List<Album>> call() async {
    return await repository.fetchAlbums();
  }
}