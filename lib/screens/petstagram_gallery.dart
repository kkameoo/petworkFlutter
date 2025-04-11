import 'package:flutter/material.dart';
import 'package:petwork/screens/detail_screen.dart';
import 'package:petwork/services/api_service.dart';

class PetstagramGallery extends StatefulWidget {
  @override
  State<PetstagramGallery> createState() => _PetstagramGalleryState();
}

class _PetstagramGalleryState extends State<PetstagramGallery> {
  late Future<List<Map<String, dynamic>>> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = fetchPetstagramPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('펫스타그램')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('업로드된 게시물이 없습니다.'));
          }

          final posts = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: posts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2개씩 가로로
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final post = posts[index];
              final imageUrl = post['imgPath']; // 서버에서 주는 이미지 경로 필드
              final title = post['title'];

              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => DetailScreen(content: title),
                  //   ),
                  // );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
