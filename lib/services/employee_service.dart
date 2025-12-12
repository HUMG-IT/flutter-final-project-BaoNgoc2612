import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  EmployeeService({required this.userId});

  // COLLECTION root (unify data source)
  CollectionReference _usersRef() {
    return _firestore.collection('users');
  }

  // STREAM: List of employees (filter by role)
  // We filter by role 'employee' to show only employees in the list
  Stream<List<UserModel>> getEmployeesStream() {
    return _usersRef()
        .where('role', isEqualTo: 'employee')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Ensure data has the ID if needed, but UserModel uses 'uid'.
            // Firestore data should already have 'uid' inside if saved correctly, 
            // but doc.id is the source of truth for ID.
            if (!data.containsKey('uid')) {
                data['uid'] = doc.id;
            }
            return UserModel.fromJson(data);
          }).toList(),
        );
  }

  // CREATE / UPDATE User (Employee Profile)
  // Since users are keyed by UID, create and update are similar operations (set/update)
  Future<UserModel?> saveEmployee(UserModel user) async {
    try {
      await _usersRef().doc(user.uid).set(user.toJson(), SetOptions(merge: true));
      return user;
    } catch (e) {
      print('Save error: $e');
      return null;
    }
  }

  // READ single
  Future<UserModel?> getEmployee(String uid) async {
    try {
      DocumentSnapshot doc = await _usersRef().doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
    } catch (e) {
      print('Get error: $e');
    }
    return null;
  }

  // DELETE
  Future<bool> deleteEmployee(String uid) async {
    try {
      // Also should probably delete from Auth via Backend API, but this just deletes profile
      await _usersRef().doc(uid).delete();
      return true;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}
