import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  EmployeeService({required this.userId});

  // COLLECTION theo userId (security)
  CollectionReference _employeesRef() {
    return _firestore.collection('users').doc(userId).collection('employees');
  }

  // STREAM: Real-time list
  Stream<List<EmployeeModel>> getEmployeesStream() {
    return _employeesRef()
        .orderBy('hireDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return EmployeeModel.fromJson(data);
          }).toList(),
        );
  }

  // CREATE
  Future<EmployeeModel?> createEmployee(EmployeeModel employee) async {
    try {
      DocumentReference docRef = await _employeesRef().add(employee.toJson());
      return employee.copyWith(id: docRef.id);
    } catch (e) {
      print('Create error: $e');
      return null;
    }
  }

  // READ single
  Future<EmployeeModel?> getEmployee(String id) async {
    try {
      DocumentSnapshot doc = await _employeesRef().doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return EmployeeModel.fromJson(data);
      }
    } catch (e) {
      print('Get error: $e');
    }
    return null;
  }

  // UPDATE
  Future<bool> updateEmployee(String id, EmployeeModel employee) async {
    try {
      await _employeesRef().doc(id).update(employee.toJson());
      return true;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }

  // DELETE
  Future<bool> deleteEmployee(String id) async {
    try {
      await _employeesRef().doc(id).delete();
      return true;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}
