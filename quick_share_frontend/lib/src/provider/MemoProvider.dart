import 'package:get/get_connect/http/src/response/response.dart';

import 'Provider.dart';

class MemoProvider extends Provider {
  // Memo 조회 (페이징 처리)
  Future<Map> index([int page = 1]) async {
    Response response = await get(
      '/api/memo',
      query: {'page': '$page'},
    );
    return response.body;
  }

  // Memo 생성 (POST)
  Future<Map> store(
    String title,
    String content,
  ) async {
    // 현재 날짜를 ISO 8601 형식으로 가져옵니다.
    String createdAt = DateTime.now().toIso8601String();
    // 'T'를 공백으로 바꾸고, 밀리초 이후 부분을 제거
    createdAt = createdAt.substring(
        0, 19); // "2025-01-21T15:45:12.638104" -> "2025-01-21 15:45:12"
    // 날짜도 body에 추가합니다.
    final Map<String, dynamic> body = {
      'title': title,
      'content': content,
      'createdAt': createdAt, // created_at 추가
    };

    print("body is $body");
    final response = await post('/api/memo', body);
    print("response is ${response.body}");

    return response.body; // body로 응답 반환
  }

  // Memo 수정 (PUT)
  Future<Map> update(int id, String title, String content) async {
    final Map<String, dynamic> body = {
      'title': title,
      'content': content,
    };
    final response = await put('/api/memo/$id', body);
    return response.body;
  }

  // // Memo 삭제 (DELETE)
  // Future<Map> delete(int id) async {
  //   final response = await delete('/api/memo/$id');
  //   return response.body;
  // }
}
