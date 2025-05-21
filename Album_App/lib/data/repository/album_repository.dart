import '../models/album.dart';
import '../models/photo.dart';

abstract class AlbumRepository {
  Future<List<Album>> fetchAlbums();
  Future<List<Photo>> fetchPhotos(int albumId);
}