import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petwork/models/board_item.dart';
import 'screens/gallery_screen.dart';
import 'pages/chat_page.dart';
import 'pages/image_test_page.dart';
import 'services/api_service.dart';
import 'screens/detail_screen.dart';
import 'screens/petstagram_gallery.dart';

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
        '/chat': (context) => ChatPage(),
        '/test': (context) => const ImageTestPage(),
        '/gallery': (context) => PetstagramGallery(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cat.jpg'), // 배경 이미지
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
        Uri.parse('http://10.0.2.2:8087/api/user/login'), // 로그인 API 엔드포인트
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("로그인 실패! 이메일 또는 비밀번호 확인")));
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
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
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
  final List<String> _categories = ['산책', '거래', '고용', '펫스타'];

  List<board_item> _boardObjectItems = [];
  // List
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBoardData(_categories[_selectedIndex]);
  }

  Future<void> _loadBoardData(String category) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await fetchBoardList(category);

      setState(() {
        _boardObjectItems =
            data.map<board_item>((item) => board_item.fromJson(item)).toList();
      });
    } catch (e) {
      print("게시글 로딩 오류: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('게시글 불러오기 실패')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Petwork 메인')),
      body: Column(
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
                    });
                    _loadBoardData(_categories[index]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == index
                            ? Colors.green
                            : Colors.grey[300],
                  ),
                  child: Text(_categories[index]),
                );
              }),
            ),
          ),
          SizedBox(height: 10),

          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/chat');
          //   },
          //   child: Text('채팅 테스트'),
          // ),
          // ElevatedButton(
          //   onPressed: () => Navigator.pushNamed(context, '/gallery'),
          //   child: Text('펫스타그램 보기'),
          // ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _boardObjectItems.isEmpty
                    ? Center(child: Text('게시글이 없습니다.'))
                    : ListView.builder(
                      itemCount: _boardObjectItems.length,
                      itemBuilder: (context, index) {
                        final item = _boardObjectItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ), // 테두리 추가
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Card와 동일한 radius
                              ),
                              child: ListTile(
                                title: Text(
                                  item.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(item: item),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
