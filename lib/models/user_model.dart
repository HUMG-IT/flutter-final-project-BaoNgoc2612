import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'employee_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { admin, manager, employee }

@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    required UserRole role,
    required Department department,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle Firestore Timestamp conversion
    if (json['createdAt'] is Timestamp) {
      json['createdAt'] = (json['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this as _UserModel);
}
