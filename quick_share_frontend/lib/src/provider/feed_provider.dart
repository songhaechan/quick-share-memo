import 'package:get/get.dart';
import 'dart:developer';

import 'provider.dart';

/// 피드 관련 API 요청을 처리하는 Provider 클래스
class FeedProvider extends Provider {
  /// 피드 목록을 가져오는 메서드
  /// [page] 페이지 번호 (기본값: 1)
  /// [isPersonal] 개인 메모 여부 (기본값: true)
  /// 반환값: API 응답 데이터를 Map 형태로 반환
  Future<Map> getList({int page = 1}) async {
    // 개인 메모와 공유받은 메모를 구분하기 위한 쿼리 파라미터
    final queryParameters = {
      'page': '$page',
    };

    // 피드 목록 API 호출
    Response response = await get('/api/feed', query: queryParameters);

    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.bodyString}');

    // 응답 데이터를 반환
    return response.body;
  }

  Future<Map> getOpenList({int page = 1}) async {
    // 개인 메모와 공유받은 메모를 구분하기 위한 쿼리 파라미터
    final queryParameters = {
      'page': '$page',
    };

    // 피드 목록 API 호출
    Response response = await get('/api/open/feed', query: queryParameters);

    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.bodyString}');

    // 응답 데이터를 반환
    return response.body;
  }
}
