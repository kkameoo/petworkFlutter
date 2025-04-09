import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchBoardList(String category) async {
  String baseUrl = 'http://192.168.0.44:8087/api/board';
  String url;

  switch (category) {
    case '산책':
      url = '$baseUrl/walk';
      break;
    case '거래':
      url = '$baseUrl/trade';
      break;
    case '고용':
      url = '$baseUrl/hire';
      break;
    case '개스타':
      url = '$baseUrl'; // 전체 리스트 받아서 boardType == 4만 필터링
      break;
    default:
      throw Exception('알 수 없는 카테고리입니다.');
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    if (category == '개스타') {
      data = data
          .where((item) => item['boardType'] == 4)
          .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
          .toList();
    }
    return data;
  } else {
    throw Exception('게시글 로드 실패: ${response.statusCode}');
  }
}

// ✅ 여기가 추가된 부분!
Future<List<Map<String, dynamic>>> fetchPetstagramPosts() async {
  final data = await fetchBoardList('개스타');
  return data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
}