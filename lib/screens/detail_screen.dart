import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String content;

  const DetailScreen({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상세 내용')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
