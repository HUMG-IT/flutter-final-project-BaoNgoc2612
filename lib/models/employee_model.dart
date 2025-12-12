import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

enum Department { it, hr, marketing, sales, finance }

enum EmployeeStatus { active, onLeave, terminated }

@freezed
sealed class EmployeeModel with _$EmployeeModel {
  const EmployeeModel._();

  const factory EmployeeModel({
    required String id,
    required String name,
    required String email,
    required String phone,
    required Department department,
    required String position,
    required double salary,
    required DateTime hireDate,
    required EmployeeStatus status,
    required String userId,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}
