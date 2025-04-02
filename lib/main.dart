import 'package:flutter/material.dart';
import 'login_page.dart';
import 'chat_page.dart';

void main() {
  // runApp(MyApp());
  runApp(MyAppChat());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter 로그인 테스트',
      home: LoginPage(), // 로그인 페이지 연결
    );
  }
}

class MyAppChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter 채팅 테스트',
      home: ChatPage(), // 채팅 페이지 실행
    );
  }
}