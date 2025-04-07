import 'dart:convert';
import 'package:http/http.dart' as http;
// 192.168.0.44
class AuthService {
  static const String baseUrl = "http://10.0.2.2:8087/api/user/login"; // 서버 IP 확인

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔹 서버 응답 코드: ${response.statusCode}");
      print("🔹 서버 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ 로그인 실패: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ 예외 발생: $e");
      return null;
    }
  }
}
