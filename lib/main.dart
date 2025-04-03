import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petwork',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text('로그인 하러 가기', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true; // 로딩 상태 표시
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.44:8087/api/user/login'), // 로그인 API 엔드포인트
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 실패! 이메일 또는 비밀번호 확인")),
        );
      }
    } catch (e) {
      print("오류 발생: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일',border: OutlineInputBorder(),),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호', border: OutlineInputBorder(),),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _login,
              child: Text('로그인', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _selectedItem;
  final List<String> _categories = ['산책', '거래', '고용', '개스타'];

  // 더미 데이터 (각 카테고리에 맞는 데이터)
  final Map<String, List<String>> _dummyData = {
    '산책': [
      '🐕 강아지 산책 도와주실 분!',
      '🌳 공원에서 함께 산책해요!'.padRight(100, '🌳 공원에서 함께 산책해요!'),
      '같이 산책 가실 분!',
      '아무나 오세요!',
      '지금 바로 가능 하신분!',
    ],
    '거래': ['📦 강아지 용품 판매합니다.', '🍖 애견 사료 교환 가능'],
    '고용': ['💼 반려견 돌봄 아르바이트 구합니다.', '🎓 강아지 훈련사 모집'],
    '개스타': ['📸 우리 강아지 너무 귀엽죠?', '🚗 오늘 반려견과 여행 갔다왔어요!'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Petwork 메인')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_categories.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                        _selectedItem = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == index ? Colors.green : Colors.grey[300],
                    ),
                    child: Text(_categories[index]),
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 500, // 리스트 영역 고정 높이 설정
              child: ListView.builder(
                itemCount: _dummyData[_categories[_selectedIndex]]!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_dummyData[_categories[_selectedIndex]]![index]),
                    onTap: () {
                      setState(() {
                        _selectedItem = _dummyData[_categories[_selectedIndex]]![index];
                      });
                    },
                  );
                },
              ),
            ),
            if (_selectedItem != null)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 100.0, // 최소 높이 설정 (내용이 짧아도 유지)
                    maxHeight: 300.0, // 최대 높이 설정 (스크롤 가능하도록)
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '상세 내용',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _selectedItem!,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Petwork 메인')),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             color: Colors.green.shade100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(_categories.length, (index) {
//                 return ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _selectedIndex == index ? Colors.green : Colors.white,
//                     foregroundColor: _selectedIndex == index ? Colors.white : Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                   child: Text(_categories[index]),
//                 );
//               }),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 '${_categories[_selectedIndex]} 리스트',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
