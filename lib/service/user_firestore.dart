import 'package:chat_application/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore{


  UserFirestore._();
  static UserFirestore userFirestore=UserFirestore._();

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


}