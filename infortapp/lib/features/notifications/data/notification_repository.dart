import '../../../shared/models/paginated_response.dart';
import '../domain/app_notification.dart';
import 'notification_api.dart';

class NotificationRepository {
  NotificationRepository(this._api);

  final NotificationApi _api;

  Future<PaginatedResponse<AppNotification>> list({
    required int page,
    int limit = 20,
  }) async {
    final response = await _api.list(page: page, limit: limit);
    return PaginatedResponse.fromJson(response, AppNotification.fromJson);
  }

  Future<void> markRead(int id) => _api.markRead(id);

  Future<void> markAllRead() => _api.markAllRead();
}
