import 'package:flutter/material.dart';
// import 'package:petwork/lib/login_service.dart';
import 'package:petwork/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;
    print("🔸 로그인 요청 시작");

    var user = await authService.login(email, password);
    if (user != null) {
      print("로그인 성공: ${user['email']}");
      // 로그인 성공 시, 메인 화면으로 이동
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      print("로그인 실패");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("로그인 실패! 이메일 또는 비밀번호 확인")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "이메일"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("🔸 로그인 요청 시작");
                handleLogin();
              },
              child: Text("로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
