import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _error = '';
  String get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void setError(String msg) {
    _error = msg;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getFirebaseError(e);
      notifyListeners();
      return false;
    }
  }

  // Signup with storing user info in Firestore
  Future<bool> signup(String email, String password,
      {String role = "student"}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Save user role in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getFirebaseError(e);
      notifyListeners();
      return false;
    }
  }


  String _getFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Email format is invalid.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}
