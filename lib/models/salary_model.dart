import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/json_converters.dart';

part 'salary_model.freezed.dart';
part 'salary_model.g.dart';

@freezed
sealed class SalaryModel with _$SalaryModel {
  const SalaryModel._();

  const factory SalaryModel({
    required String id,
    required String employeeId,
    required int month,
    required int year,
    required double basicSalary,
    required double allowance,
    required double bonus,
    required double overtimePay,
    required double totalSalary,
    required double afterTaxSalary,
    @Default('pending') String status,
    @TimestampToStringConverter() required String createdAt,
  }) = _SalaryModel;

  factory SalaryModel.fromJson(Map<String, dynamic> json) => _$SalaryModelFromJson(json);

  Map<String, dynamic> toJson();
}
