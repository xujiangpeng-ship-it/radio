import 'dart:convert';
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

  Future<List<Station>> getStations() async {
    try {
      Response response = await _dio.get('/api/stations?limit=50');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((station) => Station.fromJson(station)).toList();
        }
      }
      throw Exception('Failed to load stations');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Station>> searchStations(String query) async {
    try {
      Response response = await _dio.get('/api/stations?search=$query&limit=20');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((station) => Station.fromJson(station)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      print('Search failed: $e');
      return [];
    }
  }

  Future<Station?> getStationById(String id) async {
    try {
      Response response = await _dio.get('/api/stations/$id');
      
      if (response.statusCode == 200) {
        return Station.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      print('Get station failed: $e');
      return null;
    }
  }

  void addToFavorites(String userId, String stationId) async {
    try {
      await _dio.post('/api/favorites', data: {
        'user_id': userId,
        'station_id': stationId,
      });
    } catch (e) {
      print('Add favorite failed: $e');
    }
  }

  void removeFromFavorites(String userId, String stationId) async {
    try {
      await _dio.delete('/api/favorites/$stationId?user_id=$userId');
    } catch (e) {
      print('Remove favorite failed: $e');
    }
  }
}
