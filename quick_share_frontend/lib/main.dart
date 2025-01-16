import 'package:flutter/material.dart';
import 'package:quick_share_frontend/src/app.dart';
import 'package:quick_share_frontend/src/shared/global.dart';

void main() {
  String token = Global.accessToken;
  bool isLogin = token.isNotEmpty;
  runApp(MyApp(isLogin));
}
