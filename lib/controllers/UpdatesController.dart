// packages
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controller to Control Updates
class UpdatesController {
  final _firestore = FirebaseFirestore.instance;

  Future<void> setUserUpdateURL(String uid, String url) async {
    await _firestore.collection('users').doc(uid).update({
      'Updates.documentURL': url,
    });
  }

  Future<String?> getUserUpdateURL(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['Updates']['documentURL'];
  }
}
