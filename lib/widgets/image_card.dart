import 'package:flutter/material.dart';
import '../models/image_item.dart';

class ImageCard extends StatelessWidget {
  final ImageItem item;
  final VoidCallback onTap;

  const ImageCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: item.id,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Image.network(item.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
