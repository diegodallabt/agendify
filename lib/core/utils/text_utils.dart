import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }
}
