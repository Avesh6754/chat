class UserModal {
  String? name, email, phone, profileImage;
  bool? isOnline, isTyping;

  UserModal(
      {required this.email,
      required this.phone,
      required this.name,
      required this.profileImage,
      required this.isOnline,
      required this.isTyping});

  factory UserModal.fromMap(Map m1) {
    return UserModal(
        email: m1['email'],
        phone: m1['phone'],
        name: m1['name'],
        profileImage: m1['profileImage'],
        isOnline: m1['isOnline'],
        isTyping: m1['isTyping']);
  }

  Map<String, String?> toMap(UserModal user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'profileImage': user.profileImage,
      'isOnline': user.isOnline.toString(),
      'isTyping': user.isTyping.toString()
    };
  }
}
