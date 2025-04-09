import 'package:flutter/material.dart';
import 'package:petwork/models/image_item.dart';

class ImageDetailScreen extends StatelessWidget {
  final ImageItem content;

  const ImageDetailScreen({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(content.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content.isLocalFile
              ? Image.asset(content.imageUrl)
              : Image.network(content.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ID: ${content.id}', // 또는 다른 정보
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
