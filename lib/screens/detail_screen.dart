import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petwork/models/board_item.dart';
import 'package:petwork/services/data_service.dart';

class DetailScreen extends StatefulWidget {
  final board_item item;

  const DetailScreen({required this.item, Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<dynamic> _imageBase64 = [];

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    List<dynamic> base64Image = await DataService.getImageContent(
      widget.item.boardId.toInt(),
    );
    print(widget.item.toString());
    setState(() {
      _imageBase64 = base64Image;
    });
  }

  Widget base64ToImage(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item; // widget을 통해 item 접근

    return Scaffold(
      appBar: AppBar(title: Text('게시글 상세 보기')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                "제목 : " + item.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // 작성자, 날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '작성자: ${item.nickname ?? '엄숙한 사용자'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    (item.regDate).substring(0, 10) +
                        "  " +
                        (item.regDate).substring(11, 19),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Divider(height: 24, thickness: 1),
              // Scaffold(body: Center(child: base64ToImage(myBase64String))),
              ListView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // 스크롤은 SingleChildScrollView에 맡김
                itemCount: _imageBase64.length,
                itemBuilder: (context, index) {
                  Uint8List bytes = base64Decode(_imageBase64[index]);
                  return Image.memory(bytes);
                },
              ),

              // 내용
              Text(item.content, style: TextStyle(fontSize: 16)),

              SizedBox(height: 24),

              // 기타 정보
            ],
          ),
        ),
      ),
    );
  }
}
