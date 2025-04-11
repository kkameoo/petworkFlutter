import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// 192.168.0.44
class AuthService {
  static const String baseUrl =
      "http://10.0.2.2:8087/api/user/login/jwt"; // 서버 IP 확인

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        baseUrl,
        data: {"email": email, "password": password},
      );

      print("🔹 서버 응답 코드: ${response.statusCode}");
      print("🔹 서버 응답 본문: ${response.data}");

      if (response.statusCode == 200) {
        print("🔹 서버 응답 본문: ${response.data}");
        return response.data;
      } else {
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      print("로그인 오류 발생: $e");
      return null; // 오류 발생 시에도 null 반환
    }
  }
}
