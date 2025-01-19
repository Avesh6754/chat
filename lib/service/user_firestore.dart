import 'package:chat_application/modal/chat_Modal.dart';
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

  Future<QuerySnapshot<Map<String, dynamic>>> readAllUserFromFirestore()
  async {
    User? user=await AuthService.authService.getUser();
    return await _firestore.collection("users").where("email",isNotEqualTo:user!.email).get();
  }
  // add chat in fire store
// chatroom->
Future<void> addChatIntoFirestore(ChatModal chat)
async {
  String? sender=chat.sender;
  String? recevier=chat.recevier;
  List doc=[sender,recevier];
  doc.sort();
  String docId=doc.join("_");
  await _firestore.collection("chatroom").doc(docId).collection("chat").add(chat.toMap(chat));
}
Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFirestore(String recevier)
{
  String sender =AuthService.authService.getUser()!.email!;
  List doc=[sender,recevier];
  doc.sort();
  String docId=doc.join("_");
  return  _firestore.collection("chatroom").doc(docId).collection("chat").orderBy("time",descending: false).snapshots();
  
}
}
