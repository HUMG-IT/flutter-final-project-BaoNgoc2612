import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON', () {
      final json = {
        'uid': 'user123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'role': 'employee',
        'department': 'it',
        'createdAt': '2024-01-01T00:00:00.000',
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.role, UserRole.employee);
      expect(user.department, Department.it);
    });

    test('should convert UserModel to JSON', () {
      final user = UserModel(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.employee,
        department: Department.it,
        createdAt: DateTime(2024, 1, 1),
      );

      final json = user.toJson();

      expect(json['uid'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['role'], 'employee');
      expect(json['department'], 'it');
    });

    test('should handle all user roles', () {
      expect(UserRole.values.length, 3);
      expect(UserRole.values, contains(UserRole.manager));
      expect(UserRole.values, contains(UserRole.employee));
      expect(UserRole.values, contains(UserRole.admin));
    });
  });
}
