class FounderUser {
  const FounderUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  factory FounderUser.fromJson(Map<String, dynamic> json) {
    return FounderUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
}
