import 'dart:io';
import 'package:flutter/material.dart';
import '../models/image_item.dart';

class ImageCard extends StatelessWidget {
  final ImageItem item;
  final VoidCallback onTap;

  const ImageCard({required this.item, required this.onTap, super.key});

  // 이미지 타입에 따라 asset, file, 또는 network 로딩
  Widget _buildImage(ImageItem item) {
    if (item.isLocalFile) {
      return Image.file(
        File(item.imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (item.imageUrl.startsWith('assets/')) {
      return Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: item.id,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: _buildImage(item), // 경로 및 타입에 따라 이미지 처리
        ),
      ),
    );
  }
}
