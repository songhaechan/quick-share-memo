import 'package:flutter/material.dart';
import 'package:quick_share_frontend/src/screen/Login.dart';
import 'package:quick_share_frontend/src/screen/MemeList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
