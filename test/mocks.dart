import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/providers/auth_provider.dart';
import 'package:flutter_project/providers/employee_provider.dart';
import 'package:flutter_project/providers/language_provider.dart';

class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  bool isLoggedIn = false;
  String? userId;
  String? role;
  
  @override
  UserModel? get user => isLoggedIn ? UserModel(uid: 'test', email: 'test@test.com', displayName: 'Test', role: UserRole.manager, department: Department.it, createdAt: DateTime.now()) : null;

  @override
  Future<UserModel?> login({required String email, required String password}) async {
    if (email == 'fail@test.com') {
      throw Exception('Login failed');
    }
    isLoggedIn = true;
    notifyListeners();
    return user;
  }

  @override
  Future<void> logout() async {
    isLoggedIn = false;
    notifyListeners();
  }
  
  @override
  Future<UserModel?> register({required String email, required String password, required String name, required Department department, required UserRole role}) async {
    return null;
  }

  @override
  bool get isAuthenticated => isLoggedIn;
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockLanguageProvider extends ChangeNotifier implements LanguageProvider {
  @override
  String currentLanguage = 'en';

  @override
  String getText(String key) {
    if (key == 'app_title') return 'Employee Manager';
    if (key == 'login_title') return 'Login';
    if (key == 'email') return 'Email';
    if (key == 'password') return 'Password';
    if (key == 'login_btn') return 'Login';
    if (key == 'no_employees') return 'No Employees';
    if (key == 'search_placeholder') return 'Search...';
    if (key == 'employee_list_title') return 'Employees';
    if (key == 'dont_have_account') return 'No account?';
    if (key == 'register_btn') return 'Register';
    if (key == 'forgot_password') return 'Forgot Password?';
    if (key == 'welcome_back') return 'Welcome Back';
    return key;
  }

  @override
  Future<void> setLanguage(String lang) async {
    currentLanguage = lang;
    notifyListeners();
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockEmployeeProvider extends ChangeNotifier implements EmployeeProvider {
  @override
  List<UserModel> get employees => _employees;
  final List<UserModel> _employees = [];

  // Assuming provider logic might not expose stream directly in interface or we mock it simple
  // But if the abstract class/interface requires it, we must implement.
  // The real provider has 'employees' getter and uses stream internally.
  // Checking EmployeeProvider interface... it extends ChangeNotifier.
  // It has 'employees', 'isLoading', 'loadEmployees', 'addEmployee', etc.
  
  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;


  void setEmployees(List<UserModel> list) {
    _employees.clear();
    _employees.addAll(list);
    notifyListeners();
  }

  @override
  Future<void> loadEmployees() async {}

  @override
  Future<void> addEmployee(UserModel user) async {
      _employees.add(user);
      notifyListeners();
  }

  @override
  Future<void> updateEmployee(UserModel user) async {
     // mock update
     notifyListeners();
  }

  @override
  Future<bool> deleteEmployee(String uid) async {
      _employees.removeWhere((e) => e.uid == uid);
      notifyListeners();
      return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
