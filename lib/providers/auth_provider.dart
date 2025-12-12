import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          _user = UserModel.fromJson(userDoc.data()!);
        } else {
          // Fallback nếu chưa có data trong Firestore
          _user = UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            displayName: firebaseUser.displayName,
            role: UserRole.employee,
            department: Department.it,
            createdAt: DateTime.now(),
          );
        }
      } else {
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
}
