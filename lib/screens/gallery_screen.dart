import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../services/image_service.dart';
import 'detail_screen.dart';
import '../widgets/image_card.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<ImageItem> _images = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final urls = await ImageService.fetchImageUrls();
    setState(() {
      _images = urls.asMap().entries.map((e) => ImageItem(
        id: 'img${e.key}',
        title: '이미지 ${e.key + 1}',
        imageUrl: e.value,
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 갤러리')),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ImageCard(
            item: _images[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(item: _images[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
