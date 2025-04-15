import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cat.jpg'),
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
