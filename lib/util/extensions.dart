import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ParseDateTimeToString on DateTime {
  String formatDate() {
    final DateFormat format = DateFormat.yMd();
    return format.format(this);
  }

  String formatTime() {
    final DateFormat format = DateFormat.Hm();
    return format.format(this);
  }
}

extension ParseDateTimeToDate on DateTime {
  DateTime get nowDate {
    DateTime now = new DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get justDate {
    return DateTime(this.year, this.month, this.day);
  }
}

extension ParseIntDateTimeToString on int {
  String formatDate({bool withTime = false}) {
    final DateFormat format = DateFormat.yMd();

    if (this == null) return '';

    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    String value = format.format(date);
    if (withTime) {
      value += ' ${date.hour}:${date.minute}:${date.second}';
    }
    return value;
  }

  DateTime get justDateFromMS {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateTime(date.year, date.month, date.day);
  }
}
