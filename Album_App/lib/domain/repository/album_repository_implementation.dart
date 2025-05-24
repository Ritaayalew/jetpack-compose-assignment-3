import 'dart:convert';
import '../../data/models/album.dart';
import '../../data/models/photo.dart';
import '../../data/repository/album_repository.dart';
import 'package:http/http.dart' as http;

class AlbumRepositoryImplementation implements AlbumRepository {
  final http.Client _client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  AlbumRepositoryImplementation() : _client = http.Client() {
    print('AlbumRepositoryImplementation constructor called at ${DateTime.now()} EAT');
  }

  @override
  Future<List<Album>> fetchAlbums() async {
    print('Fetching albums at ${DateTime.now()} EAT');
    try {
      final response = await _client.get(Uri.parse('$baseUrl/albums')).timeout(
        const Duration(seconds: 5), // Timeout to avoid hanging
        onTimeout: () => throw Exception('Request timed out'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Album.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching albums: $e');
      // Fallback: Return empty list if network fails (temporary)
      return [];
    } finally {
      // Note: Client is not closed here; consider using a singleton or closing in dispose
    }
  }

  @override
  Future<List<Photo>> fetchPhotos(int albumId) async {
    print('Fetching photos for album $albumId at ${DateTime.now()} EAT');
    try {
      final response = await _client.get(Uri.parse('$baseUrl/photos?albumId=$albumId')).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Request timed out'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching photos: $e');
      return []; // Fallback
    }
  }

  // Optional: Close client when disposing (if managed manually)
  void dispose() {
    _client.close();
    print('http.Client closed at ${DateTime.now()} EAT');
  }
}