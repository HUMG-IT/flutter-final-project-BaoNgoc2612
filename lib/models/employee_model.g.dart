// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    _EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      department: $enumDecode(_$DepartmentEnumMap, json['department']),
      position: json['position'] as String,
      salary: (json['salary'] as num).toDouble(),
      hireDate: DateTime.parse(json['hireDate'] as String),
      status: $enumDecode(_$EmployeeStatusEnumMap, json['status']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'department': _$DepartmentEnumMap[instance.department]!,
      'position': instance.position,
      'salary': instance.salary,
      'hireDate': instance.hireDate.toIso8601String(),
      'status': _$EmployeeStatusEnumMap[instance.status]!,
      'userId': instance.userId,
    };

const _$DepartmentEnumMap = {
  Department.it: 'it',
  Department.hr: 'hr',
  Department.marketing: 'marketing',
  Department.sales: 'sales',
  Department.finance: 'finance',
};

const _$EmployeeStatusEnumMap = {
  EmployeeStatus.active: 'active',
  EmployeeStatus.onLeave: 'onLeave',
  EmployeeStatus.terminated: 'terminated',
};
