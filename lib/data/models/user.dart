enum UserType { passenger, driver, admin }

extension UserTypeX on UserType {
  String get label => switch (this) {
        UserType.passenger => 'Pasajero',
        UserType.driver => 'Chofer',
        UserType.admin => 'Admin',
      };
  String get value => name;
}

class AppUserProfile {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final UserType role;

  AppUserProfile({
    required this.id,
    required this.role,
    this.fullName,
    this.email,
    this.phone,
  });

  factory AppUserProfile.fromMap(Map<String, dynamic> m) {
    final roleStr = (m['role'] as String?) ?? 'passenger';
    return AppUserProfile(
      id: m['id'] as String,
      fullName: m['full_name'] as String?,
      email: m['email'] as String?,
      phone: m['phone'] as String?,
      role: UserType.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserType.passenger,
      ),
    );
  }
}
