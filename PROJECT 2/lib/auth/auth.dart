// packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check internet connectivity
  Future<bool> _hasInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Show Snackbar with appropriate color
  void _showSnackBar(BuildContext context, String message, bool isError) {
    final color = isError
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.surfaceContainerHigh;

    final textColor = isError
        ? Theme.of(context).colorScheme.onErrorContainer
        : Theme.of(context).colorScheme.onSurface;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: color,
      ),
    );
  }

  // Register function with name and phone
  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
    BuildContext context,
  ) async {
    if (!await _hasInternet()) {
      _showSnackBar(context, 'No internet connection', true);
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (context) => false);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, e.message ?? 'Registration failed', true);
    }
  }

  // Login function
  Future<void> login(String email, String password, BuildContext context) async {
    if (!await _hasInternet()) {
      _showSnackBar(context, 'No internet connection', true);
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (context) => false);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, e.message ?? 'Login failed', true);
    }
  }

  // Check if user is logged in
  bool isLogged() {
    return _auth.currentUser != null;
  }

  // Get user details
  User? getUserDetails() {
    return _auth.currentUser;
  }

  // Edit user details (update Firebase Auth + Firestore)
  Future<void> editUser({
    required String name,
    required String phone,
    required BuildContext context,
  }) async {
    if (!await _hasInternet()) {
      _showSnackBar(context, 'No internet connection', true);
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();

        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'phone': phone,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        _showSnackBar(context, 'Profile updated successfully', false);
      } else {
        _showSnackBar(context, 'No user logged in', true);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, e.message ?? 'Profile update failed', true);
    } catch (e) {
      _showSnackBar(context, 'Something went wrong', true);
    }
  }
}
