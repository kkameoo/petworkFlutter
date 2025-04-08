import 'package:flutter/material.dart';

class ImageTestPage extends StatelessWidget {
  const ImageTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 테스트')),
      body: Center(child: Text('여기에 이미지 테스트를 넣을 수 있어요')),
    );
  }
}
