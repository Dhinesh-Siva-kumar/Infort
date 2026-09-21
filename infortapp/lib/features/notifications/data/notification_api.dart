import '../../../core/network/api_client.dart';

class NotificationApi {
  NotificationApi(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> list({required int page, required int limit}) {
    return _client.get('/notifications', query: {'page': page, 'limit': limit});
  }

  Future<void> markRead(int id) {
    return _client.patch('/notifications/$id/read');
  }

  Future<void> markAllRead() {
    return _client.patch('/notifications/read-all');
  }

  Future<void> registerDeviceToken(String token, String platform) {
    return _client.post(
      '/notifications/device-token',
      data: {'token': token, 'platform': platform},
    );
  }
}
