import 'package:dio/dio.dart';
import '../models/station.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://global-broadcast-api.wicro.workers.dev',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List<Station>> getStations({int limit = 50, String? country, String? genre}) async {
    try {
      var queryParameters = <String, dynamic>{'limit': limit.toString()};
      if (country != null) queryParameters['country'] = country;
      if (genre != null) queryParameters['genre'] = genre;

      Response response = await _dio.get('/api/stations', queryParameters: queryParameters);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((station) => Station.fromJson(station)).toList();
        }
      }
      throw Exception('Failed to load stations');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Station?> searchStations(String query) async {
    try {
      Response response = await _dio.get('/api/stations', queryParameters: {'search': query, 'limit': '20'});
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).firstOrNull?.let((station) => Station.fromJson(station));
        }
      }
      return null;
    } catch (e) {
      print('Search failed: $e');
      return null;
    }
  }

  Future<void> addToFavorites(String userId, String stationId) async {
    try {
      await _dio.post('/api/favorites', data: {
        'user_id': userId,
        'station_id': stationId,
      });
    } catch (e) {
      print('Add favorite failed: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String stationId) async {
    try {
      await _dio.delete('/api/favorites/$stationId', queryParameters: {'user_id': userId});
    } catch (e) {
      print('Remove favorite failed: $e');
    }
  }
}
