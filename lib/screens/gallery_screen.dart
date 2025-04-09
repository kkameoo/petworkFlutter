import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/image_item.dart';
import 'package:petwork/screens/image_detail_screen.dart';
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
    _requestPermissionAndLoadImages();
  }

  /// 권한 요청 + 이미지 로딩
  Future<void> _requestPermissionAndLoadImages() async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    // 권한 승인 시 이미지 로드
    await loadImages();
  }

  /// 실제 이미지 로딩
  Future<void> loadImages() async {
    final localAssetImages = [
      'assets/basic.jpg',
      'assets/petDog1.jpg',
      'assets/petDog2.jpg',
      'assets/petDog3.jpg',
    ];

    final deviceImagePath = '/storage/emulated/0/Download/Basic.jpg';

    setState(() {
      _images = [
        if (File(deviceImagePath).existsSync())
          ImageItem(
            id: 'device_img',
            title: '디바이스 이미지',
            imageUrl: deviceImagePath,
            isLocalFile: true,
          ),
        ...localAssetImages.asMap().entries.map((e) => ImageItem(
          id: 'img${e.key}',
          title: '이미지 ${e.key + 1}',
          imageUrl: e.value,
          isLocalFile: false,
        )),
      ];
    });
  }

  /// 권한 거부 시 알림
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('권한 필요'),
        content: Text('이미지를 불러오기 위해 저장소 접근 권한이 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 갤러리')),
      body: _images.isEmpty
          ? Center(child: Text('불러올 이미지가 없습니다'))
          : GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ImageCard(
            item: _images[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageDetailScreen(content: _images[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
