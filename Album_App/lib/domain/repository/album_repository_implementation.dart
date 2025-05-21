import 'dart:convert';
import 'package:album_app/data/models/album.dart';
import 'package:album_app/data/models/photo.dart';
import 'package:album_app/data/repository/album_repository.dart';
import 'package:http/http.dart' as http;

class AlbumRepositoryImplementation implements AlbumRepository {
  final client = http.Client();
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  @override
  Future<List<Album>> fetchAlbums() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/albums'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Album.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<Photo>> fetchPhotos(int albumId) async {
    try {
      final response =
      await client.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}