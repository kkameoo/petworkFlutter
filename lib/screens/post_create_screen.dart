import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostCreateScreen extends StatefulWidget {
  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _submitPost() {
    final text = _textController.text;
    if (text.isEmpty || _image == null) return;

    // TODO: 서버에 업로드 로직 작성
    print('텍스트: $text');
    print('이미지 경로: ${_image!.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('새 글 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: '내용 입력'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('이미지를 선택해주세요')
                : Image.file(_image!, height: 200),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('이미지 선택'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
