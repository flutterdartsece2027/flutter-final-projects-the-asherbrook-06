// packages
import 'package:cloud_firestore/cloud_firestore.dart';

// models
import 'package:buzz/models/Call.dart';

/// Controller to Control Calls
class CallController {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  Future<void> addCall(String userUID, Call call) async {
    await _users.doc(userUID).update({
      'calls': FieldValue.arrayUnion([call.toMap()])
    });
  }
}
