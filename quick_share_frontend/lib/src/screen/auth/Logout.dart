import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quick_share_frontend/src/screen/auth/Login.dart';
import 'package:quick_share_frontend/src/shared/global.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 제품 버전 텍스트
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Text(
              '제품 버전: 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          // 로그아웃 버튼
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 버튼 배경색
                padding: EdgeInsets.symmetric(vertical: 14), // 버튼 높이
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                ),
              ),
              onPressed: () {
                Global.accessToken = '';
                Get.to(() => LoginScreen());
              },
              child: Text(
                '로그아웃',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
