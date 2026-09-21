import '../../../shared/models/paginated_response.dart';
import '../domain/contact_request.dart';
import '../domain/contact_summary.dart';
import 'contact_api.dart';

enum ContactSort { newest, oldest }

class ContactRepository {
  ContactRepository(this._api);

  final ContactApi _api;

  Future<PaginatedResponse<ContactRequest>> list({
    required int page,
    int limit = 20,
    String? search,
    ContactStatus? status,
    ContactSort sort = ContactSort.newest,
  }) async {
    final response = await _api.list(
      page: page,
      limit: limit,
      search: search,
      status: status?.toApi(),
      sort: sort == ContactSort.newest ? 'newest' : 'oldest',
    );
    return PaginatedResponse.fromJson(response, ContactRequest.fromJson);
  }

  Future<ContactSummary> summary() async {
    final response = await _api.summary();
    return ContactSummary.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ContactRequest> getById(int id) async {
    final response = await _api.getById(id);
    return ContactRequest.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ContactRequest> updateStatus(int id, ContactStatus status) async {
    final response = await _api.updateStatus(id, status.toApi());
    return ContactRequest.fromJson(response['data'] as Map<String, dynamic>);
  }
}
