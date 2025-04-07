import 'package:flutter/material.dart';
import '../models/image_item.dart';

class DetailScreen extends StatelessWidget {
  final ImageItem item;

  const DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Center(
        child: Hero(
          tag: item.id,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(item.imageUrl, height: 300, fit: BoxFit.cover),
              SizedBox(height: 20),
              Text(
                item.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "여기에 상세 설명이 들어갑니다.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
