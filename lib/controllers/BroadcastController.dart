// packages
import 'package:cloud_firestore/cloud_firestore.dart';

// models
import 'package:buzz/models/message.dart';
import 'package:buzz/models/chat.dart';

class BroadcastController {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _chats => _firestore.collection('chats');

  /// Create a broadcast entry
  Future<void> createBroadcast({
    required String creatorUID,
    required String broadcastName,
    required List<String> recipients,
    String profilePicURL = '',
  }) async {
    final docRef = _chats.doc();
    final broadcastChat = Chat(
      chatID: docRef.id,
      members: recipients,
      admins: [creatorUID],
      displayName: broadcastName,
      profilePicURL: profilePicURL,
      isGroup: false,
      isBroadcast: true,
      createdAt: Timestamp.now(),
      lastMessage: '',
      lastMessageTime: Timestamp.now(),
      lastMessageSender: '',
    );

    await docRef.set(broadcastChat.toMap());
  }

  /// Send a broadcast message to all members privately
  Future<void> sendBroadcastMessage({
    required String broadcastID,
    required Message message,
  }) async {
    final doc = await _chats.doc(broadcastID).get();
    if (!doc.exists) throw Exception('Broadcast not found');

    final data = doc.data() as Map<String, dynamic>;
    final List<String> recipients = List<String>.from(data['members']);
    final String senderUID = message.sender;

    // Optional: store message in broadcast chat for history
    await _chats
        .doc(broadcastID)
        .collection('messages')
        .doc(message.messageID)
        .set(message.toMap());

    // Send to each user privately as a 1-on-1 chat
    for (String recipientUID in recipients) {
      final privateChatID = _getPrivateChatID(senderUID, recipientUID);
      final privateChatRef = _chats.doc(privateChatID);

      // Create chat if it doesn't exist
      final chatExists = (await privateChatRef.get()).exists;
      if (!chatExists) {
        final newChat = Chat(
          chatID: privateChatID,
          members: [senderUID, recipientUID],
          admins: [senderUID],
          displayName: '',
          profilePicURL: '',
          isGroup: false,
          isBroadcast: false,
          createdAt: Timestamp.now(),
          lastMessage: '',
          lastMessageTime: Timestamp.now(),
          lastMessageSender: '',
        );
        await privateChatRef.set(newChat.toMap());
      }

      // Send the message
      final messageRef = privateChatRef
          .collection('messages')
          .doc('${message.messageID}_${DateTime.now().millisecondsSinceEpoch}');
      await messageRef.set(message.toMap());

      // Update chat preview
      await privateChatRef.update({
        'lastMessage': message.text,
        'lastMessageSender': message.sender,
        'lastMessageTime': message.sentAt,
      });
    }
  }

  /// Generate a consistent chat ID for 1-on-1 chat
  String _getPrivateChatID(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
