import 'package:get/get.dart';

import 'provider.dart';
import 'dart:developer';

/// 피드 관련 API 요청을 처리하는 Provider 클래스
class FeedProvider extends Provider {
  /// 피드 목록을 가져오는 메서드
  /// [page] 페이지 번호 (기본값: 1)
  /// 반환값: API 응답 데이터를 Map 형태로 반환
  Future<Map> getList({int page = 1}) async {
    // 피드 목록 API 호출
    Response response = await get('/api/feed', query: {'page': '$page'});

    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.bodyString}');

    return response.body;
  }
}
