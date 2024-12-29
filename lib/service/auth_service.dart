import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  AuthService._();
  static AuthService authService=AuthService._();

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<void> createAccountWithEmailAndPassword(String email,String password)
  async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<String> sigInWithEmailAndPassword(String email,String password)
  async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    }catch(e)
    {
      return e.toString();
    }
  }

  Future<void> logoutUser()
  async {
    await _firebaseAuth.signOut();
  }

  User? getUser()
  {
    User? user = _firebaseAuth.currentUser;
    if(user!=null)
      {
        log('Login ${user.email}');
      }
    return user;
  }
}