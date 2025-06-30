import 'package:flutter/material.dart';

class ReminderManager {
  static final ReminderManager _instance = ReminderManager._internal();
  factory ReminderManager() => _instance;
  ReminderManager._internal();

  static ReminderManager get instance => _instance;

  final List<Map<String, dynamic>> _reminders = [];

  void addReminder(String medicine, TimeOfDay time) {
    _reminders.add({'medicine': medicine, 'time': time});
  }

  List<Map<String, dynamic>> get reminders => _reminders;

  void clear() => _reminders.clear();
}
