import 'dart:convert';
import 'dart:typed_data';
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

  /// 다섯번째 API: 신체 부위 목록 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises/bodyPartList
  static Future<List<String>> getBodyPartList() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises/bodyPartList'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load body part list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching body part list: $e');
    }
  }

  /// 여섯번째 API: 특정 신체 부위의 운동 목록 가져오기
  /// GET https://exercisedb.p.rapidapi.com/exercises/bodyPart/{bodyPart}
  static Future<List<dynamic>> getExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/exercises/bodyPart/$bodyPart'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exercises for body part $bodyPart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises for body part $bodyPart: $e');
    }
  }

  /// 일곱번째 API: 운동 이미지 가져오기
  /// GET https://exercisedb.p.rapidapi.com/image?exerciseId={exerciseId}&resolution=1080
  static Future<Uint8List> getExerciseImage(String exerciseId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/image?exerciseId=$exerciseId&resolution=1080'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        // API가 바이너리 이미지 데이터를 반환하므로 bodyBytes를 직접 사용
        print('Image API Response length: ${response.bodyBytes.length} bytes');
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load exercise image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercise image: $e');
    }
  }

  /// hex 문자열을 바이트 배열로 변환하는 헬퍼 메서드
  static Uint8List _hexStringToBytes(String hex) {
    try {
      // 공백과 개행 제거
      hex = hex.replaceAll(RegExp(r'\s+'), '');
      
      // hex 문자열이 유효한지 확인
      if (!RegExp(r'^[0-9A-Fa-f]+$').hasMatch(hex)) {
        throw FormatException('Invalid hex string: $hex');
      }
      
      if (hex.length % 2 != 0) {
        hex = '0$hex'; // 홀수 길이인 경우 앞에 0 추가
      }
      
      final bytes = <int>[];
      for (int i = 0; i < hex.length; i += 2) {
        final byteString = hex.substring(i, i + 2);
        bytes.add(int.parse(byteString, radix: 16));
      }
      return Uint8List.fromList(bytes);
    } catch (e) {
      throw FormatException('Failed to parse hex string: $e');
    }
  }
}
