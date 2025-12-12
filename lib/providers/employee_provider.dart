import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/employee_service.dart';
import '../models/employee_model.dart';

class EmployeeProvider with ChangeNotifier {
  final String userId;
  EmployeeService? _service;
  List<EmployeeModel> _employees = [];
  bool _isLoading = false;

  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EmployeeProvider({required this.userId}) {
    _service = EmployeeService(userId: userId);
    _loadEmployees();
  }

  Stream<List<EmployeeModel>> get employeesStream =>
      _service!.getEmployeesStream();

  Future<void> _loadEmployees() async {
    setLoading(true);
    // Initial load từ stream
    setLoading(false);
  }

  // Method mới: Load employees từ Firestore
  Future<void> loadEmployees(String userId) async {
    _isLoading = true;
    notifyListeners();

    final snapshot = await _firestore
        .collection('employees')
        .where('userId', isEqualTo: userId)
        .get();

    _employees = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return EmployeeModel.fromJson(data);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Method mới: Add employee
  Future<void> addEmployee(EmployeeModel employee) async {
    await _service!.createEmployee(employee);
    notifyListeners();
  }

  // Method mới: Update employee
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _service!.updateEmployee(employee.id, employee);
    notifyListeners();
  }

  Future<EmployeeModel?> create(EmployeeModel employee) async {
    setLoading(true);
    try {
      final result = await _service!.createEmployee(employee);
      if (result != null) _employees.add(result);
      notifyListeners();
      return result;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> update(String id, EmployeeModel employee) async {
    setLoading(true);
    try {
      final success = await _service!.updateEmployee(id, employee);
      if (success) {
        final index = _employees.indexWhere((e) => e.id == id);
        if (index != -1) _employees[index] = employee;
        notifyListeners();
      }
      return success;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> delete(String id) async {
    setLoading(true);
    try {
      final success = await _service!.deleteEmployee(id);
      if (success) {
        _employees.removeWhere((e) => e.id == id);
        notifyListeners();
      }
      return success;
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
