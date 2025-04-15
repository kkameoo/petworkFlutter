import 'package:dio/dio.dart';

class DataService {
  static const String _apiBaseUrl =
      "http://ec2-52-78-69-115.ap-northeast-2.compute.amazonaws.com:18087/api/photo/board/upload";

  static Future<List<dynamic>> getImageContent(int userId) async {
    try {
      var dio = Dio();
      String url = "$_apiBaseUrl/$userId";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("이미지 조회 실패");
      }
    } catch (e) {
      print("이미지 불러오기 오류: $e");
      return [];
    }
  }
}
