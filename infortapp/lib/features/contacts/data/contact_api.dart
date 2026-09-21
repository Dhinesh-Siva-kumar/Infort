import '../../../core/network/api_client.dart';

class ContactApi {
  ContactApi(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> list({
    required int page,
    required int limit,
    String? search,
    String? status,
    required String sort,
  }) {
    return _client.get(
      '/contact-requests',
      query: {
        'page': page,
        'limit': limit,
        'sort': sort,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
      },
    );
  }

  Future<Map<String, dynamic>> summary() {
    return _client.get('/contact-requests/summary');
  }

  Future<Map<String, dynamic>> getById(int id) {
    return _client.get('/contact-requests/$id');
  }

  Future<Map<String, dynamic>> updateStatus(int id, String status) {
    return _client.patch(
      '/contact-requests/$id/status',
      data: {'status': status},
    );
  }
}
