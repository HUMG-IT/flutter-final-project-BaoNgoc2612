import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      try {
        if (firebaseUser != null) {
          // Force reload to get latest emailVerified status
          await firebaseUser.reload();
          
          // Re-fetch current user after reload to ensure we have the updated object
          final currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser == null || !currentUser.emailVerified) {
            _user = null;
            notifyListeners();
            return;
          }

          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (userDoc.exists) {
            _user = UserModel.fromJson(userDoc.data()!);
          } else {
            // Fallback nếu chưa có data trong Firestore
            final isHardcodedAdmin = currentUser.email == 'admin@gmail.com';
            _user = UserModel(
              uid: currentUser.uid,
              email: currentUser.email!,
              displayName: currentUser.displayName,
              role: isHardcodedAdmin ? UserRole.admin : UserRole.employee,
              department: isHardcodedAdmin ? Department.it : Department.it,
              createdAt: DateTime.now(),
              position: isHardcodedAdmin ? 'System Administrator' : 'Staff',
              status: 'Active',
            );
          }
        } else {
          _user = null;
        }
      } catch (e) {
        debugPrint('Auth State Error: $e');
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required Department department,
    required UserRole role,
  }) async {
    _user = await _authService.register(
      email: email,
      password: password,
      name: name,
      department: department,
      role: role,
    );
    notifyListeners();
    return _user;
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    _user = await _authService.login(email: email, password: password);
    notifyListeners();
    return _user;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> resendVerificationEmail(String email, String password) async {
    await _authService.resendVerificationEmail(email, password);
  }
}
