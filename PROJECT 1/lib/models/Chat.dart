// packages
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model to store Chat Details
class Chat {
  final String chatID;
  final List<String> members;
  final List<String> admins;
  final String displayName;
  final String profilePicURL;
  final bool isGroup;
  final bool isBroadcast;
  final Timestamp createdAt;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final String lastMessageSender;

  Chat({
    required this.chatID,
    required this.members,
    required this.admins,
    required this.displayName,
    required this.profilePicURL,
    required this.isGroup,
    required this.isBroadcast,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSender,
  });

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      chatID: id,
      members: List<String>.from(map['members']),
      admins: List<String>.from(map['admins']),
      displayName: map['displayName'] ?? '',
      profilePicURL: map['profilePicURL'] ?? '',
      isGroup: map['isGroup'] ?? false,
      isBroadcast: map['isBroadcast'] ?? false,
      createdAt: map['createdAt'],
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'],
      lastMessageSender: map['lastMessageSender'],
    );
  }

  Map<String, dynamic> toMap() => {
    'members': members,
    'admins': admins,
    'displayName': displayName,
    'profilePicURL': profilePicURL,
    'isGroup': isGroup,
    'isBroadcast': isBroadcast,
    'createdAt': createdAt,
    'lastMessage': lastMessage,
    'lastMessageTime': lastMessageTime,
    'lastMessageSender': lastMessageSender,
  };
}
