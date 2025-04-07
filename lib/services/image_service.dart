import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<List<String>> fetchImageUrls() async {
    // 실제 API 연동 시 수정
    return [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRokYXj-QEVGUtHznxdBr-SzR2nHn0M0FvcsQ&s/300x300',
      'https://cdn.pixabay.com/photo/2016/01/02/18/39/puppy-1118584_640.jpg/301x301',
    ];
  }

  static Future<String?> uploadImage(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://your-api-url/upload'), // 내API주소
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      return jsonDecode(respStr)['url'];
    } else {
      return null;
    }
  }
}
