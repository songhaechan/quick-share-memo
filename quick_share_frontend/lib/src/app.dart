import 'package:flutter/material.dart';
import 'package:quick_share_frontend/src/screen/auth/Login.dart';
import 'package:quick_share_frontend/src/screen/auth/Register.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp(this.isLogin, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
      initialRoute: '/',
    );
  }
}
