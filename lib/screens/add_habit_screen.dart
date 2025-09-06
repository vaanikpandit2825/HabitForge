import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget
{
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> 
{
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final habit = _controller.text.trim();
                if (habit.isNotEmpty) {
                  Navigator.pop(context, habit);
                }
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}


