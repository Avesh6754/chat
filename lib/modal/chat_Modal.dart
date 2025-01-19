import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String? sender, recevier, message;
  Timestamp? time;

  ChatModal(
      {required this.message,
      required this.recevier,
      required this.sender,
      required this.time});

  factory ChatModal.fromMap(Map m1) {
    return ChatModal(
        message: m1['message'],
        recevier: m1['recevier'],
        sender: m1['sender'],
        time: m1['time']);
  }

  Map<String, Object?> toMap(ChatModal chat)
  {
    return {'message':chat.message,'sender':chat.sender,'recevier':chat.recevier,'time':chat.time};
  }
}
