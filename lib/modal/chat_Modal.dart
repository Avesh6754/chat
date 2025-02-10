import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String? sender, recevier, message,status;
  Timestamp? time;
  bool? isImage;

  ChatModal(
      {required this.message,
      required this.recevier,
      required this.sender,
      required this.time,
      required this.isImage});

  factory ChatModal.fromMap(Map m1) {
    return ChatModal(
        message: m1['message'],
        recevier: m1['recevier'],
        sender: m1['sender'],
        time: m1['time'],
    isImage: m1['isImage']);
  }

  Map<String, Object?> toMap(ChatModal chat)
  {
    return {'message':chat.message,'sender':chat.sender,'recevier':chat.recevier,'time':chat.time,'isImage':isImage};
  }
}
