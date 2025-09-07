import 'package:flutter/material.dart';
import 'habit.dart';
import 'habit_progress_chart.dart';

class HabitDetailsScreen extends StatelessWidget{
  final Habit habit;
  const HabitDetailsScreen({super.key, required this.habit});

  List<int> _getWeeklyData(){
    final now = DateTime.now();
    List<int> data = [];
    for (int i = 6; i >= 0; i--)
    {
      final day = DateTime(now.year, now.month, now.day - i);
      data.add(habit.history.any((d) =>
              d.year == day.year && d.month == day.month && d.day == day.day)
          ? 1
          : 0);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) 
  {
    final weeklyData = _getWeeklyData();
    return Scaffold(
      appBar: AppBar(title: Text('${habit.name} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Habit: ${habit.name}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Current Streak: ${habit.streak} 🔥",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            const Text("Progress This Week",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            HabitProgressChart(data: weeklyData),
          ],
        ),
      ),
    );
  }
}






