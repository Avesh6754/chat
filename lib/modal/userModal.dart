class UserModal {
  String? name, email, phone;

  UserModal({required this.email, required this.phone, required this.name});

  factory UserModal.fromMap(Map m1) {
    return UserModal(email: m1['email'], phone: m1['phone'], name: m1['name']);
  }

  Map<String, String?> toMap(UserModal user) {
    return {'name': user.name, 'email': user.email, 'phone': user.phone};
  }
}
