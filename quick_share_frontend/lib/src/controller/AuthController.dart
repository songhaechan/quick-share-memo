import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_share_frontend/src/provider/AuthProvider.dart';
import 'package:quick_share_frontend/src/shared/global.dart';

class AuthController extends GetxController {
  final authProvider = Get.put(AuthProvider());

  Future<bool> login(String id, String password) async {
    Map body = await authProvider.login(id, password);
    if (body['result'] == 'ok') {
      String token = body['access_token'];
      log("token : $token"); // 'dart:developer' 패키지 내의 log 함수
      Global.accessToken = token;
      return true;
    }
    Get.snackbar('로그인 에러', body['message'],
        snackPosition: SnackPosition.BOTTOM);
    return false;
  }

  Future<bool> register(String id, String password) async {
    Map body = await authProvider.register(id, password);
    if (body['result'] == 'ok') {
      String token = body['access_token'];
      log("token : $token"); // 'dart:developer' 패키지 내의 log 함수
      Global.accessToken = token;
      return true;
    }
    Get.snackbar('회원가입 에러', body['message'],
        snackPosition: SnackPosition.BOTTOM);
    return false;
  }
}
