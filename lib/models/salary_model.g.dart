// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalaryModel _$SalaryModelFromJson(Map<String, dynamic> json) => _SalaryModel(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  basicSalary: (json['basicSalary'] as num).toDouble(),
  allowance: (json['allowance'] as num).toDouble(),
  bonus: (json['bonus'] as num).toDouble(),
  overtimePay: (json['overtimePay'] as num).toDouble(),
  totalSalary: (json['totalSalary'] as num).toDouble(),
  afterTaxSalary: (json['afterTaxSalary'] as num).toDouble(),
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$SalaryModelToJson(_SalaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'month': instance.month,
      'year': instance.year,
      'basicSalary': instance.basicSalary,
      'allowance': instance.allowance,
      'bonus': instance.bonus,
      'overtimePay': instance.overtimePay,
      'totalSalary': instance.totalSalary,
      'afterTaxSalary': instance.afterTaxSalary,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };
