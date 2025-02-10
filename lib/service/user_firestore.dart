import 'dart:math';
import 'dart:developer';

import 'package:chat_application/modal/chat_Modal.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserFirestore {
  UserFirestore._();

  static UserFirestore userFirestore = UserFirestore._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModal user) async {
    await _firestore.collection("users").doc(user.email).set({
      'email': user.email,
      'name': user.name,
      'phone': user.phone,
      'profileImage': user.profileImage,
      'isOnline': user.isOnline,
      'isTyping': user.isTyping
    });
    print(
        "=========================================${user.name} ======================${user.phone} =============================${user.profileImage}=====================${user.isTyping}=======================${user.isOnline}");
  }

  Future<void> updateProfilePhoto({required String url, userEmail}) async {
    await _firestore
        .collection("users")
        .doc(userEmail)
        .update({'profileImage': url});
    print("======================Image============$url");
  }

  Future<void> editStatus(
      {required String email,
      required bool online,
      required bool typing}) async {
    await _firestore
        .collection("users")
        .doc(email)
        .update({'isOnline': online,});
  }

  Future<UserModal> getCurrentUserAndShow() async {
    User? user = AuthService.authService.getUser();
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(user!.email).get();
    final data = snapshot.data() as Map<String, dynamic>?;
    UserModal userModal = UserModal.fromMap(data!);
    return userModal;
  }
  Future<Map<String, dynamic>?> fetchReceiverData(String text)
  async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await
    _firestore.collection('users')
        .doc(text)
    .get();
    final data = snapshot.data();
    return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAllUserFromFirestore()  {
    User? user = AuthService.authService.getUser();
    return  _firestore
        .collection("users")
        .where("email", isNotEqualTo: user!.email)
        .snapshots();
  }
  Stream<String> getProfileImage(String text)
  {
    User? user = AuthService.authService.getUser();
    return  _firestore
        .collection("users").doc(text).snapshots().map((event) => event.data()!['profileImage'],);
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> isActive(String text)
  {
    return  _firestore
        .collection("users").doc(text).snapshots();
  }
  Future<void> updateUserName(String name)
  async {
    User? user = AuthService.authService.getUser();
    await _firestore
        .collection("users")
        .doc(user!.email)
        .update({'name':name});
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSatuts(String text)
  {
   return _firestore.collection('users')
        .doc(text)
        .snapshots();
  }

  // add chat in fire store
// chatroom->
  Future<void> addChatIntoFirestore(ChatModal chat) async {
    String? sender = chat.sender;
    String? recevier = chat.recevier;
    List doc = [sender, recevier];
    doc.sort();
    String docId = doc.join("_");
    await _firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFirestore(
      String recevier) {
    String sender = AuthService.authService.getUser()!.email!;
    List doc = [sender, recevier];
    doc.sort();
    String docId = doc.join("_");
    return _firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> updateMessage(
      {required String recevier,
      required String message,
      required String updateId}) async {
    String sender = AuthService.authService.getUser()!.email!;
    List doc = [sender, recevier];
    doc.sort();
    String docId = doc.join("_");
    await _firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(updateId)
        .update({'message': message});
  }

  Future<void> deleteMessage(
      {required String recevier, required String removeId}) async {
    String sender = AuthService.authService.getUser()!.email!;
    List doc = [sender, recevier];
    doc.sort();
    String docId = doc.join("_");
    await _firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(removeId)
        .delete()
        .then((value) => Get.snackbar('Message Deleted !', ''));
  }

}
