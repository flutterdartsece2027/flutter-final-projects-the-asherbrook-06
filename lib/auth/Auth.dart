// packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

/// Class to handle Authentication
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get current user
  Future<User?> getCurrentUser(BuildContext context) async {
    try {
      return _auth.currentUser;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Check if user is logged in and navigate accordingly
  void checkLoggedIn(BuildContext context) {
    if (_auth.currentUser != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  /// Register user with email and password
  Future<void> register(BuildContext context, String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        await storeUserDataToFirestore(user, name);
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      debugPrint('Register error: $e');
      _showError(context, 'Registration failed.');
    }
  }

  /// Login with email and password
  Future<void> login(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      debugPrint('Login error: $e');
      _showError(context, 'Login failed.');
    }
  }

  /// Logout the user
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  /// Edit user's profile (name and about)
  Future<void> editProfile(String name, String about) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'about': about,
      });
    }
  }

  /// Update profile picture using image picker
  Future<void> updateProfilePicture(BuildContext context) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        File image = File(picked.path);

        final ref = _storage.ref().child('users/$uid/ProfilePicture.jpg');
        await ref.putFile(image);
        String downloadURL = await ref.getDownloadURL();

        await _firestore.collection('users').doc(uid).update({
          'profilePic': downloadURL,
        });
      }
    } catch (e) {
      debugPrint('Profile picture update failed: $e');
      _showError(context, 'Could not update profile picture.');
    }
  }

  /// Store user data in Firestore after registration
  Future<void> storeUserDataToFirestore(User user, String name) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email ?? '',
      'about': '',
      'phoneNumber': user.phoneNumber ?? '',
      'profilePic': '',
      'contacts': [],
      'calls': [],
      'Updates': {'documentURL': ''}
    });
  }

  /// Show error using snackbar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
