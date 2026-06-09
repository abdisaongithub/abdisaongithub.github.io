import 'package:dio/dio.dart';

class GithubService {
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.github.com/'));

  Future<Map<String, dynamic>> getUserStats(String username) async {
    try {
      final response = await _dio.get('users/$username');
      return response.data;
    } catch (e) {
      print('Error fetching GitHub stats: $e');
      return {};
    }
  }

  Future<List<dynamic>> getRecentCommits(String username) async {
    try {
      final response = await _dio.get('users/$username/events/public');
      return response.data as List<dynamic>;
    } catch (e) {
      print('Error fetching GitHub events: $e');
      return [];
    }
  }
}
