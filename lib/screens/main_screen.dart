import 'package:flutter/material.dart';
import '../models/board_item.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _categories = ['산책', '거래', '고용', '펫스타'];

  List<board_item> _boardObjectItems = [];
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
                                ),
                                borderRadius: BorderRadius.circular(12),
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
