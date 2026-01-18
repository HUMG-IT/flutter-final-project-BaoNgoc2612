// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      department: $enumDecode(_$DepartmentEnumMap, json['department']),
      createdAt: const FirestoreDateTimeConverter()
          .fromJson(json['createdAt'] as Object),
      phone: json['phone'] as String? ?? '',
      baseSalary: (json['baseSalary'] as num?)?.toDouble() ?? 0,
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
      status: json['status'] as String? ?? 'Active',
      position: json['position'] as String? ?? 'Staff',
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'department': _$DepartmentEnumMap[instance.department]!,
      'createdAt':
          const FirestoreDateTimeConverter().toJson(instance.createdAt),
      'phone': instance.phone,
      'baseSalary': instance.baseSalary,
      'hireDate': instance.hireDate?.toIso8601String(),
      'status': instance.status,
      'position': instance.position,
    };

const _$UserRoleEnumMap = {
  UserRole.manager: 'manager',
  UserRole.employee: 'employee',
  UserRole.admin: 'admin',
};

const _$DepartmentEnumMap = {
  Department.it: 'it',
  Department.hr: 'hr',
  Department.marketing: 'marketing',
  Department.sales: 'sales',
  Department.finance: 'finance',
  Department.operations: 'operations',
  Department.other: 'other',
};
