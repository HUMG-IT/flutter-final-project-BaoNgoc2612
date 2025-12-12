import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/models/employee_model.dart';

void main() {
  group('EmployeeModel', () {
    test('should create EmployeeModel from JSON', () {
      final json = {
        'id': '123',
        'name': 'Nguyễn Văn A',
        'email': 'nguyenvana@example.com',
        'phone': '0123456789',
        'department': 'it',
        'position': 'Developer',
        'salary': 15000000.0,
        'hireDate': '2024-01-01T00:00:00.000',
        'status': 'active',
        'userId': 'user123',
      };

      final employee = EmployeeModel.fromJson(json);

      expect(employee.id, '123');
      expect(employee.name, 'Nguyễn Văn A');
      expect(employee.email, 'nguyenvana@example.com');
      expect(employee.department, Department.it);
      expect(employee.status, EmployeeStatus.active);
      expect(employee.salary, 15000000.0);
    });

    test('should convert EmployeeModel to JSON', () {
      final employee = EmployeeModel(
        id: '123',
        name: 'Nguyễn Văn A',
        email: 'nguyenvana@example.com',
        phone: '0123456789',
        department: Department.it,
        position: 'Developer',
        salary: 15000000.0,
        hireDate: DateTime(2024, 1, 1),
        status: EmployeeStatus.active,
        userId: 'user123',
      );

      final json = employee.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Nguyễn Văn A');
      expect(json['email'], 'nguyenvana@example.com');
      expect(json['department'], 'it');
      expect(json['status'], 'active');
      expect(json['salary'], 15000000.0);
    });

    test('should handle all departments', () {
      expect(Department.values.length, 5);
      expect(Department.values, contains(Department.it));
      expect(Department.values, contains(Department.hr));
      expect(Department.values, contains(Department.marketing));
      expect(Department.values, contains(Department.sales));
      expect(Department.values, contains(Department.finance));
    });

    test('should handle all employee statuses', () {
      expect(EmployeeStatus.values.length, 3);
      expect(EmployeeStatus.values, contains(EmployeeStatus.active));
      expect(EmployeeStatus.values, contains(EmployeeStatus.onLeave));
      expect(EmployeeStatus.values, contains(EmployeeStatus.terminated));
    });
  });
}
