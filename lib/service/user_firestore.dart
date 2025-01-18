import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestore {
  UserFirestore._();

  static UserFirestore userFirestore = UserFirestore._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModal user) async {
    await _firestore.collection("users").doc(user.email).set(
        { 'email': user.email,'name':user.name,'phone':user.phone});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserAndShow()
  async {
    User? user=await AuthService.authService.getUser();
    return await _firestore.collection("users").doc(user!.email).get();
  }
}
