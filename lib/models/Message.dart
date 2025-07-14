// packages
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model to store Message Details
class Message {
  final String messageID;
  final String replyTo;
  final bool isEdited;
  final String text;
  final String messageType;
  final String sender;
  final Timestamp sentAt;
  final String status;

  Message({
    required this.messageID,
    required this.replyTo,
    required this.isEdited,
    required this.text,
    required this.messageType,
    required this.sender,
    required this.sentAt,
    required this.status,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      messageID: id,
      replyTo: map['replyTo'] ?? '',
      isEdited: map['isEdited'] ?? false,
      text: map['text'] ?? '',
      messageType: map['messageType'] ?? 'text',
      sender: map['sender'],
      sentAt: map['sentAt'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() => {
        'replyTo': replyTo,
        'isEdited': isEdited,
        'text': text,
        'messageType': messageType,
        'sender': sender,
        'sentAt': sentAt,
        'status': status,
      };
}
