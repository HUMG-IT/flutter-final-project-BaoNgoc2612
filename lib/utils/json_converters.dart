import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class FirestoreDateTimeConverter implements JsonConverter<DateTime, Object> {
  const FirestoreDateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    return DateTime.now(); // Fallback or throw
  }

  @override
  Object toJson(DateTime object) => object.toIso8601String();
}

class TimestampToStringConverter implements JsonConverter<String, Object> {
  const TimestampToStringConverter();

  @override
  String fromJson(Object json) {
    if (json is Timestamp) {
      return json.toDate().toIso8601String();
    }
    return json.toString();
  }

  @override
  Object toJson(String object) => object;
}
