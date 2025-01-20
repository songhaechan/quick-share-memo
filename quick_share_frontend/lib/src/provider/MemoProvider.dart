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
    final Map<String, dynamic> body = {
      'title': title,
      'content': content,
    };

    print("body is $body");
    final response = await post('/api/memo', body);
    print("response is $response");

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
