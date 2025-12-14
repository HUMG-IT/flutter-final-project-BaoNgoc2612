import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // REGISTER
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required Department department,
    required UserRole role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);

        // Send verification email
        await user.sendEmailVerification();

        // Create UserModel & save to Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: name,
          role: role,
          department: department,
          createdAt: DateTime.now(),
          phone: '',
          baseSalary: 0,
          status: 'Active',
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        return userModel;

      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
    return null;
  }

  // LOGIN
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Check if email is verified
        if (!result.user!.emailVerified) {
          await _auth.signOut();
          throw Exception(
            'Email chưa được xác thực. Vui lòng kiểm tra email và xác thực tài khoản.',
          );
        }

        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          debugPrint('User Data: $userData');
          return UserModel.fromJson(userData);
        } else if (result.user!.email == 'admin@gmail.com') {
          // Fallback for admin if firestore doc is missing
          return UserModel(
            uid: result.user!.uid,
            email: result.user!.email!,
            displayName: result.user!.displayName,
            role: UserRole.admin,
            department: Department.it,
            createdAt: DateTime.now(),
            position: 'System Administrator',
            status: 'Active',
          );
        } else {
           throw Exception('User data not found in database');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
    return null;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // RESEND VERIFICATION EMAIL
  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        if (!result.user!.emailVerified) {
          await result.user!.sendEmailVerification();
        }
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-not-found':
        return 'Không tìm thấy user';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Thông tin đăng nhập không chính xác (Sai email hoặc mật khẩu)';
      default:
        return 'Lỗi: ${e.message ?? e.code}';
    }
  }
}
