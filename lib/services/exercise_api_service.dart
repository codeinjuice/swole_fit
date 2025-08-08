import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String _apiKey = '7a534681c4msh1a36eab61e2a2b5p13b94cjsn052204b849d7';
  static const String _apiHost = 'exercisedb.p.rapidapi.com';

  static Map<String, String> get _headers => {
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  /// 첫번째 API: 모든 운동 목록 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises
  static Future<List<dynamic>> getAllExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }

  /// 두번째 API: 운동 부위 목록 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises/targetList
  static Future<List<String>> getTargetList() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises/targetList'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load target list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching target list: $e');
    }
  }

  /// 세번째 API: 특정 운동 정보 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises/exercise/{id}
  static Future<Map<String, dynamic>> getExerciseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises/exercise/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exercise: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercise: $e');
    }
  }

  /// 네번째 API: 특정 부위의 운동 목록 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises/target/{target}
  static Future<List<dynamic>> getExercisesByTarget(String target) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises/target/$target'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exercises for target $target: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises for target $target: $e');
    }
  }
}
