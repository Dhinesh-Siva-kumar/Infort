import 'package:flutter_test/flutter_test.dart';
import 'package:infortapp/features/contacts/domain/contact_request.dart';

void main() {
  group('ContactStatusX', () {
    test('maps every API status string to the correct enum value', () {
      expect(ContactStatusX.fromApi('NEW'), ContactStatus.newRequest);
      expect(ContactStatusX.fromApi('READ'), ContactStatus.read);
      expect(ContactStatusX.fromApi('IN_PROGRESS'), ContactStatus.inProgress);
      expect(ContactStatusX.fromApi('REPLIED'), ContactStatus.replied);
      expect(ContactStatusX.fromApi('CLOSED'), ContactStatus.closed);
    });

    test('round-trips toApi/fromApi for every status', () {
      for (final status in ContactStatus.values) {
        expect(ContactStatusX.fromApi(status.toApi()), status);
      }
    });

    test('falls back to NEW for an unrecognized status', () {
      expect(
        ContactStatusX.fromApi('SOMETHING_UNKNOWN'),
        ContactStatus.newRequest,
      );
    });
  });

  group('ContactRequest.fromJson', () {
    final json = {
      'id': 1,
      'name': 'Jane Doe',
      'email': 'jane@example.com',
      'phone': '9876543210',
      'service': 'web-development',
      'message': 'Hello there',
      'status': 'READ',
      'created_at': '2026-09-21T16:56:16.200Z',
      'updated_at': '2026-09-21T17:23:11.984Z',
    };

    test('parses all fields correctly', () {
      final request = ContactRequest.fromJson(json);

      expect(request.id, 1);
      expect(request.name, 'Jane Doe');
      expect(request.email, 'jane@example.com');
      expect(request.status, ContactStatus.read);
      expect(request.createdAt, DateTime.parse('2026-09-21T16:56:16.200Z'));
    });

    test('defaults status to NEW when missing', () {
      final withoutStatus = Map<String, dynamic>.from(json)..remove('status');
      expect(
        ContactRequest.fromJson(withoutStatus).status,
        ContactStatus.newRequest,
      );
    });

    test('copyWith replaces only the status', () {
      final request = ContactRequest.fromJson(json);
      final updated = request.copyWith(status: ContactStatus.closed);

      expect(updated.status, ContactStatus.closed);
      expect(updated.id, request.id);
      expect(updated.email, request.email);
    });
  });
}
