// packages
import 'package:cloud_firestore/cloud_firestore.dart';

// models
import 'package:buzz/models/User.dart';

/// Controller to manage Users and their Contacts
class UserController {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  // ------------------- User Functions -------------------

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  Stream<UserModel> userStream(String uid) {
    return _users.doc(uid).snapshots().map(
          (doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>),
        );
  }

  // ------------------- Contact Functions -------------------

  /// Add a contact UID to user's contact list
  Future<void> addContact(String userUID, String contactUID) async {
    await _users.doc(userUID).update({
      'contacts': FieldValue.arrayUnion([contactUID]),
    });
  }

  /// Remove a contact UID from user's contact list
  Future<void> removeContact(String userUID, String contactUID) async {
    await _users.doc(userUID).update({
      'contacts': FieldValue.arrayRemove([contactUID]),
    });
  }

  /// Get a specific contact UID from user's contact list
  Future<String?> getContact(String userUID, String contactUID) async {
    final doc = await _users.doc(userUID).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    final List contacts = data['contacts'] ?? [];

    return contacts.contains(contactUID) ? contactUID : null;
  }

  /// Get all contact UIDs from user's contact list
  Future<List<String>> getContactsList(String userUID) async {
    final doc = await _users.doc(userUID).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>;
    return List<String>.from(data['contacts'] ?? []);
  }
}
