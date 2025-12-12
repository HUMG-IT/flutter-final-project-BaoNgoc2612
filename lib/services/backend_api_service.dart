import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendApiService {
  // Change this URL based on your backend deployment
  // For local development: http://localhost:3000
  // For production: your deployed backend URL
  static const String baseUrl = 'http://localhost:3000';

  /// Create employee account via backend API
  /// This method calls the backend server which uses Firebase Admin SDK
  /// to create accounts without affecting the current user's session
  static Future<Map<String, dynamic>> createEmployeeAccount({
    required String email,
    required String password,
    required String displayName,
    String role = 'employee',
  }) async {
    try {
      print('API Request: POST $baseUrl/api/employees/create-account');
      print('Body: ${json.encode({
          'email': email,
          'password': password,
          'displayName': displayName,
          'role': role,
      })}');

      final response = await http.post(
        Uri.parse('$baseUrl/api/employees/create-account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'displayName': displayName,
          'role': role,
        }),
      );
      
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'uid': data['uid'],
          'email': data['email'],
          'displayName': data['displayName'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to create account',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Delete employee account via backend API
  static Future<Map<String, dynamic>> deleteEmployeeAccount(String uid) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/employees/$uid'),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to delete account',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Check if backend server is running
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
