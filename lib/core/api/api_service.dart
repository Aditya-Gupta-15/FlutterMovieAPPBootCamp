import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movieapp/core/api/network_models/movie_model.dart';
import 'package:movieapp/core/constants/api_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService(){
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization' : 'Bearer $bearerToken',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log the request
          developer.log('🚀 Making API request to: ${options.uri}', name: 'API_SERVICE');
          return handler.next(options); // continue with the request
        },
        onResponse: (response, handler) {
          // Log the response
          developer.log('✅ API Call Successful!', name: 'API_SERVICE');
          developer.log('📄 Status Code: ${response.statusCode}', name: 'API_SERVICE');
          developer.log('📊 Content-Length: ${response.headers['content-length']}', name: 'API_SERVICE');
          return handler.next(response); // continue with the response
        },
        onError: (DioException e, handler) {
          // Log the error
          developer.log('❌ API Error: ${e.response?.statusCode}', name: 'API_SERVICE', level: 1000);
          developer.log('Response: ${e.response?.data}', name: 'API_SERVICE', level: 1000);
          return handler.next(e); // continue with the error
        },
      ),
    );
  }

  Future<List<MovieNetworkModel>> getPopularMovies() async{
    try {
      final response = await _dio.get('/movie/popular', queryParameters: {
        'language': 'en-US',
        'page': 1,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];
        return results.map((e) => MovieNetworkModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load popular movies: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Exception: $e');
      throw Exception('Failed to load popular movies: $e');
    }
  }

  Future<List<MovieNetworkModel>> searchMovieApiService(String query) async{
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        'query': query,
        'language': 'en-US',
        'page': 1,
      });

      debugPrint("📄 Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final List results = data['results'] ?? [];
        if (results.isNotEmpty) {
          return results.map((e) => MovieNetworkModel.fromJson(e)).toList();
        } else {
          throw Exception('No results found for query: $query');
        }
      } else {
        throw Exception('Failed to search movie: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Exception: $e');
      throw Exception('Failed to search movie: $e');
    }
  }
  
}
