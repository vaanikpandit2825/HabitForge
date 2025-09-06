import 'package:flutter/material.dart';

class Habit {
  String name;
  bool isCompleted;
  int streak;
  int xp;
  DateTime? lastCompleted;
  List<DateTime> history;
  TimeOfDay? reminderTime;

  Habit({
    required this.name,
    this.isCompleted = false,
    this.streak = 0,
    this.reminderTime,
    this.xp = 0,
    this.lastCompleted,
    List<DateTime>? history,
  }) : history = history ?? [];
}
