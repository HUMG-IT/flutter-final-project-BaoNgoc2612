import 'package:flutter/foundation.dart';
import '../services/employee_service.dart';
import '../models/user_model.dart';

class EmployeeProvider with ChangeNotifier {
  final String userId;
  EmployeeService? _service;
  List<UserModel> _employees = [];
  bool _isLoading = false;

  List<UserModel> get employees => _employees;
  bool get isLoading => _isLoading;

  EmployeeProvider({required this.userId}) {
    _service = EmployeeService(userId: userId);
    _initStream();
  }

  void _initStream() {
    _service!.getEmployeesStream().listen((employees) {
      _employees = employees;
      notifyListeners();
    });
  }

  // Reload manually if needed (mostly handled by stream)
  Future<void> loadEmployees() async {
    _isLoading = true;
    notifyListeners();
    // Logic handled by stream listener, but could force fetch if needed.
    // For now, stream is sufficient.
    _isLoading = false;
    notifyListeners();
  }

  // Add/Create Employee
  Future<void> addEmployee(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service!.saveEmployee(user);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Employee
  Future<void> updateEmployee(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service!.saveEmployee(user); // saveEmployee uses set with merge, so updates work too
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete Employee
  Future<bool> deleteEmployee(String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _service!.deleteEmployee(uid);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
