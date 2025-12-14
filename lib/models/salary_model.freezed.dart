// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalaryModel {
  String get id;
  String get employeeId;
  int get month;
  int get year;
  double get basicSalary;
  double get allowance;
  double get bonus;
  double get overtimePay;
  double get totalSalary;
  double get afterTaxSalary;
  String get status;
  @TimestampToStringConverter()
  String get createdAt;

  /// Create a copy of SalaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SalaryModelCopyWith<SalaryModel> get copyWith =>
      _$SalaryModelCopyWithImpl<SalaryModel>(this as SalaryModel, _$identity);

  /// Serializes this SalaryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SalaryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.basicSalary, basicSalary) ||
                other.basicSalary == basicSalary) &&
            (identical(other.allowance, allowance) ||
                other.allowance == allowance) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.overtimePay, overtimePay) ||
                other.overtimePay == overtimePay) &&
            (identical(other.totalSalary, totalSalary) ||
                other.totalSalary == totalSalary) &&
            (identical(other.afterTaxSalary, afterTaxSalary) ||
                other.afterTaxSalary == afterTaxSalary) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      month,
      year,
      basicSalary,
      allowance,
      bonus,
      overtimePay,
      totalSalary,
      afterTaxSalary,
      status,
      createdAt);

  @override
  String toString() {
    return 'SalaryModel(id: $id, employeeId: $employeeId, month: $month, year: $year, basicSalary: $basicSalary, allowance: $allowance, bonus: $bonus, overtimePay: $overtimePay, totalSalary: $totalSalary, afterTaxSalary: $afterTaxSalary, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $SalaryModelCopyWith<$Res> {
  factory $SalaryModelCopyWith(
          SalaryModel value, $Res Function(SalaryModel) _then) =
      _$SalaryModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String employeeId,
      int month,
      int year,
      double basicSalary,
      double allowance,
      double bonus,
      double overtimePay,
      double totalSalary,
      double afterTaxSalary,
      String status,
      @TimestampToStringConverter() String createdAt});
}

/// @nodoc
class _$SalaryModelCopyWithImpl<$Res> implements $SalaryModelCopyWith<$Res> {
  _$SalaryModelCopyWithImpl(this._self, this._then);

  final SalaryModel _self;
  final $Res Function(SalaryModel) _then;

  /// Create a copy of SalaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? month = null,
    Object? year = null,
    Object? basicSalary = null,
    Object? allowance = null,
    Object? bonus = null,
    Object? overtimePay = null,
    Object? totalSalary = null,
    Object? afterTaxSalary = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _self.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      basicSalary: null == basicSalary
          ? _self.basicSalary
          : basicSalary // ignore: cast_nullable_to_non_nullable
              as double,
      allowance: null == allowance
          ? _self.allowance
          : allowance // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      overtimePay: null == overtimePay
          ? _self.overtimePay
          : overtimePay // ignore: cast_nullable_to_non_nullable
              as double,
      totalSalary: null == totalSalary
          ? _self.totalSalary
          : totalSalary // ignore: cast_nullable_to_non_nullable
              as double,
      afterTaxSalary: null == afterTaxSalary
          ? _self.afterTaxSalary
          : afterTaxSalary // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SalaryModel].
extension SalaryModelPatterns on SalaryModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SalaryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SalaryModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SalaryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalaryModel():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SalaryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalaryModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String employeeId,
            int month,
            int year,
            double basicSalary,
            double allowance,
            double bonus,
            double overtimePay,
            double totalSalary,
            double afterTaxSalary,
            String status,
            @TimestampToStringConverter() String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SalaryModel() when $default != null:
        return $default(
            _that.id,
            _that.employeeId,
            _that.month,
            _that.year,
            _that.basicSalary,
            _that.allowance,
            _that.bonus,
            _that.overtimePay,
            _that.totalSalary,
            _that.afterTaxSalary,
            _that.status,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String employeeId,
            int month,
            int year,
            double basicSalary,
            double allowance,
            double bonus,
            double overtimePay,
            double totalSalary,
            double afterTaxSalary,
            String status,
            @TimestampToStringConverter() String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalaryModel():
        return $default(
            _that.id,
            _that.employeeId,
            _that.month,
            _that.year,
            _that.basicSalary,
            _that.allowance,
            _that.bonus,
            _that.overtimePay,
            _that.totalSalary,
            _that.afterTaxSalary,
            _that.status,
            _that.createdAt);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String employeeId,
            int month,
            int year,
            double basicSalary,
            double allowance,
            double bonus,
            double overtimePay,
            double totalSalary,
            double afterTaxSalary,
            String status,
            @TimestampToStringConverter() String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalaryModel() when $default != null:
        return $default(
            _that.id,
            _that.employeeId,
            _that.month,
            _that.year,
            _that.basicSalary,
            _that.allowance,
            _that.bonus,
            _that.overtimePay,
            _that.totalSalary,
            _that.afterTaxSalary,
            _that.status,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SalaryModel extends SalaryModel {
  const _SalaryModel(
      {required this.id,
      required this.employeeId,
      required this.month,
      required this.year,
      required this.basicSalary,
      required this.allowance,
      required this.bonus,
      required this.overtimePay,
      required this.totalSalary,
      required this.afterTaxSalary,
      this.status = 'pending',
      @TimestampToStringConverter() required this.createdAt})
      : super._();
  factory _SalaryModel.fromJson(Map<String, dynamic> json) =>
      _$SalaryModelFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final int month;
  @override
  final int year;
  @override
  final double basicSalary;
  @override
  final double allowance;
  @override
  final double bonus;
  @override
  final double overtimePay;
  @override
  final double totalSalary;
  @override
  final double afterTaxSalary;
  @override
  @JsonKey()
  final String status;
  @override
  @TimestampToStringConverter()
  final String createdAt;

  /// Create a copy of SalaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SalaryModelCopyWith<_SalaryModel> get copyWith =>
      __$SalaryModelCopyWithImpl<_SalaryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SalaryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalaryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.basicSalary, basicSalary) ||
                other.basicSalary == basicSalary) &&
            (identical(other.allowance, allowance) ||
                other.allowance == allowance) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.overtimePay, overtimePay) ||
                other.overtimePay == overtimePay) &&
            (identical(other.totalSalary, totalSalary) ||
                other.totalSalary == totalSalary) &&
            (identical(other.afterTaxSalary, afterTaxSalary) ||
                other.afterTaxSalary == afterTaxSalary) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      month,
      year,
      basicSalary,
      allowance,
      bonus,
      overtimePay,
      totalSalary,
      afterTaxSalary,
      status,
      createdAt);

  @override
  String toString() {
    return 'SalaryModel(id: $id, employeeId: $employeeId, month: $month, year: $year, basicSalary: $basicSalary, allowance: $allowance, bonus: $bonus, overtimePay: $overtimePay, totalSalary: $totalSalary, afterTaxSalary: $afterTaxSalary, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$SalaryModelCopyWith<$Res>
    implements $SalaryModelCopyWith<$Res> {
  factory _$SalaryModelCopyWith(
          _SalaryModel value, $Res Function(_SalaryModel) _then) =
      __$SalaryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeId,
      int month,
      int year,
      double basicSalary,
      double allowance,
      double bonus,
      double overtimePay,
      double totalSalary,
      double afterTaxSalary,
      String status,
      @TimestampToStringConverter() String createdAt});
}

/// @nodoc
class __$SalaryModelCopyWithImpl<$Res> implements _$SalaryModelCopyWith<$Res> {
  __$SalaryModelCopyWithImpl(this._self, this._then);

  final _SalaryModel _self;
  final $Res Function(_SalaryModel) _then;

  /// Create a copy of SalaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? month = null,
    Object? year = null,
    Object? basicSalary = null,
    Object? allowance = null,
    Object? bonus = null,
    Object? overtimePay = null,
    Object? totalSalary = null,
    Object? afterTaxSalary = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_SalaryModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _self.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      basicSalary: null == basicSalary
          ? _self.basicSalary
          : basicSalary // ignore: cast_nullable_to_non_nullable
              as double,
      allowance: null == allowance
          ? _self.allowance
          : allowance // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      overtimePay: null == overtimePay
          ? _self.overtimePay
          : overtimePay // ignore: cast_nullable_to_non_nullable
              as double,
      totalSalary: null == totalSalary
          ? _self.totalSalary
          : totalSalary // ignore: cast_nullable_to_non_nullable
              as double,
      afterTaxSalary: null == afterTaxSalary
          ? _self.afterTaxSalary
          : afterTaxSalary // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
