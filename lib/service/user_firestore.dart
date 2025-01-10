import 'package:chat_application/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestore {
  UserFirestore._();

  static UserFirestore userFirestore = UserFirestore._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser({required String email,name,phone}) async {
    await _firestore.collection("users").doc(email).set(
        { 'email': email,'name':name,'phone':phone});
  }
}
