import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';

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

        // Tự động gán role dựa trên email nếu là admin
        UserRole finalRole = role;
        if (email.contains('admin') || email.endsWith('@admin.com')) {
          finalRole = UserRole.admin;
        } else if (email.contains('manager')) {
          finalRole = UserRole.manager;
        }

        // Create UserModel & save to Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: name,
          role: finalRole,
          department: department,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        // Nếu là Role Employee hoặc Manager, tự động tạo hồ sơ nhân viên
        if (role != UserRole.admin) {
          final employeeModel = EmployeeModel(
            id: '', // Will be generated or same as uid
            userId: user.uid,
            name: name,
            email: email,
            phone: '', // User will update later
            department: department,
            position: role == UserRole.manager ? 'Manager' : 'Staff',
            salary: 0,
            hireDate: DateTime.now(),
            status: EmployeeStatus.active,
          );
          
          await _firestore
              .collection('employees')
              .add(employeeModel.toJson());
        }

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

        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
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
