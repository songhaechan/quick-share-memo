import 'Provider.dart';

class AuthProvider extends Provider {
  Future<Map> login(String id, String password) async {
    final response = await post('/auth/login', {
      'id': id,
      'password': password,
    });
    return response.body;
  }

  Future<Map> register(String id, String password) async {
    print("id = $id, password = $password");
    final response = await post('/auth/register', {
      'id': id,
      'password': password,
    });
    // 응답 상태 코드와 본문 출력
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    return response.body;
  }
}
