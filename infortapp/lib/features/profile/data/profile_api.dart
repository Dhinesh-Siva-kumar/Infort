import '../../../core/network/api_client.dart';

class ProfileApi {
  ProfileApi(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> update({String? name, String? phone}) {
    return _client.patch('/profile', data: {'name': ?name, 'phone': ?phone});
  }
}
