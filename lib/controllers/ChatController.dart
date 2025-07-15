// packages
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// models
import 'package:buzz/models/Message.dart';
import 'package:buzz/models/Chat.dart';

/// Controller to Control Chats
class ChatController {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _chats => _firestore.collection('chats');
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  String get currentUserEmail => FirebaseAuth.instance.currentUser?.email ?? '';

  /// Get a chat by chatID
  Future<Chat?> getChatById(String chatID) async {
    final doc = await _chats.doc(chatID).get();
    if (doc.exists) {
      return Chat.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Fetch All chats that user is a part of
  Future<List<Chat>> getChatsForUser(String userID) async {
    final querySnapshot = await _chats.where('members', arrayContains: userID).get();
    return querySnapshot.docs.map((doc) {
      return Chat.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  /// Get a Stream of Chats for a User
  Stream<List<Chat>>? getChatsOverviewStream(String userID, bool isGroup, bool isBroadcast) {
    return _chats
        .where('members', arrayContains: userID)
        .where('isGroup', isEqualTo: isGroup)
        .where('isBroadcast', isEqualTo: isBroadcast)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
          var query = querySnapshot.docs.map((doc) {
            return Chat.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();
          log(query.first.members.toString());
          return query;
        });
  }

  /// Create Chat
  Future<void> createChat(Chat chat) async {
    await _chats.doc(chat.chatID).set(chat.toMap());
  }

  /// Update Chat
  Future<void> updateChat(Chat chat) async {
    await _chats.doc(chat.chatID).update(chat.toMap());
  }

  /// Delete Chat
  Future<void> deleteChat(String chatID) async {
    await _chats.doc(chatID).delete();
  }

  /// Get a Chat Stream of a Chat
  Stream<Chat> chatStream(String chatID) {
    return _chats.doc(chatID).snapshots().map((doc) => Chat.fromMap(doc.id, doc.data() as Map<String, dynamic>));
  }

  /// Subcollection: Messages
  CollectionReference getMessages(String chatID) {
    return _chats.doc(chatID).collection('messages');
  }

  Future<void> sendMessage(String chatID, String messageText, String sender, String replyTo) async {
    final messageRef = getMessages(chatID).doc();
    final message = Message(
      messageID: messageRef.id,
      status: 'sent',
      sender: sender,
      isEdited: false,
      replyTo: replyTo,
      text: messageText,
      messageType: 'text',
      sentAt: Timestamp.now(),
    );

    await messageRef.set(message.toMap());
    await _chats.doc(chatID).update({
      'lastMessage': message.text,
      'lastMessageSender': message.sender,
      'lastMessageTime': message.sentAt,
    });
  }

  /// Edit Message (Only if type is 'text')
  Future<void> editMessage(String chatID, String messageID, String newText) async {
    final docRef = getMessages(chatID).doc(messageID);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['messageType'] == 'text') {
        await docRef.update({'text': newText, 'isEdited': true});
      }
    }
  }

  /// Unsend (Delete) a Message
  Future<void> unsendMessage(String chatID, String messageID) async {
    await getMessages(chatID).doc(messageID).delete();
  }

  /// Clear all message history in a chat
  Future<void> clearHistory(String chatID) async {
    final messagesRef = getMessages(chatID);
    final snapshots = await messagesRef.get();
    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  /// Get a Message Stream of a Chat
  Stream<List<Message>> messageStream(String chatID) {
    return getMessages(chatID)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Message.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }
}
