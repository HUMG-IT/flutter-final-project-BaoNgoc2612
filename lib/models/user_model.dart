import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/json_converters.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { manager, employee }
enum Department { it, hr, marketing, sales, finance, operations, other }

@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    required UserRole role,
    required Department department,
    @FirestoreDateTimeConverter() required DateTime createdAt,
    @Default('') String phone,
    @Default(0) double baseSalary,
    DateTime? hireDate,
    @Default('Active') String status,
    @Default('Staff') String position,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
