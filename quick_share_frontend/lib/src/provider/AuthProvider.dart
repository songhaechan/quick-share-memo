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
    final response = await post('/auth/register', {
      'id': id,
      'password': password,
    });
    return response.body;
  }
}
