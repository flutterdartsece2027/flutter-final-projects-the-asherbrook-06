// packages
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Controller to Control Storage
class StorageController {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadUserProfilePic(String uid, File file) async {
    final ref = _storage.ref('users/$uid/ProfilePicture.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadChatImage(String chatID, File file) async {
    final ref = _storage.ref('chat/$chatID/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // TODO: Add more: About uploads, document uploads, etc.
}
