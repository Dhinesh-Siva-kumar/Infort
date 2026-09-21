enum ContactStatus { newRequest, read, inProgress, replied, closed }

extension ContactStatusX on ContactStatus {
  static ContactStatus fromApi(String value) {
    switch (value) {
      case 'NEW':
        return ContactStatus.newRequest;
      case 'READ':
        return ContactStatus.read;
      case 'IN_PROGRESS':
        return ContactStatus.inProgress;
      case 'REPLIED':
        return ContactStatus.replied;
      case 'CLOSED':
        return ContactStatus.closed;
      default:
        return ContactStatus.newRequest;
    }
  }

  String toApi() {
    switch (this) {
      case ContactStatus.newRequest:
        return 'NEW';
      case ContactStatus.read:
        return 'READ';
      case ContactStatus.inProgress:
        return 'IN_PROGRESS';
      case ContactStatus.replied:
        return 'REPLIED';
      case ContactStatus.closed:
        return 'CLOSED';
    }
  }

  String get label {
    switch (this) {
      case ContactStatus.newRequest:
        return 'New';
      case ContactStatus.read:
        return 'Read';
      case ContactStatus.inProgress:
        return 'In Progress';
      case ContactStatus.replied:
        return 'Replied';
      case ContactStatus.closed:
        return 'Closed';
    }
  }
}

class ContactRequest {
  const ContactRequest({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.service,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactRequest.fromJson(Map<String, dynamic> json) {
    return ContactRequest(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      service: json['service'] as String,
      message: json['message'] as String,
      status: ContactStatusX.fromApi(json['status'] as String? ?? 'NEW'),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? json['created_at'] as String,
      ),
    );
  }

  final int id;
  final String name;
  final String email;
  final String phone;
  final String service;
  final String message;
  final ContactStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactRequest copyWith({ContactStatus? status}) {
    return ContactRequest(
      id: id,
      name: name,
      email: email,
      phone: phone,
      service: service,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
