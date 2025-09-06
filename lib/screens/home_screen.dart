import 'package:flutter/material.dart';
import 'habit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  int totalXp = 0;
  int level = 1;

  void _completeHabit(Habit habit) {
    setState(() {
      if (!habit.isCompleted) {
        habit.isCompleted = true;
        habit.streak++;
        habit.xp += 10;
        totalXp += 10;
        habit.lastCompleted = DateTime.now();
        habit.history.add(DateTime.now());

        // Level up logic
        if (totalXp >= level * 100) {
          level++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habit Hero (Lvl $level)"),
        centerTitle: true,
      ),
      body: habits.isEmpty
          ? const Center(child: Text("No habits yet. Add one!"))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(habit.name),
                    subtitle: habit.reminderTime != null
                        ? Text(
                            "Reminder: ${habit.reminderTime!.format(context)}")
                        : null,
                    trailing: IconButton(
                      icon: Icon(
                        habit.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: habit.isCompleted ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => _completeHabit(habit),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();
          TimeOfDay? pickedTime;

          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("New Habit"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Habit name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // text color
                        backgroundColor: Colors.deepPurple, // button color
                      ),
                      child: const Text("Pick reminder time"),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary:
                                      Colors.deepPurple, // header background
                                  onPrimary: Colors.white, // header text
                                  onSurface: Colors.black, // body text
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.deepPurple, // buttons
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (time != null) {
                          setState(() {
                            pickedTime = time; // update correctly
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          habits.add(Habit(
                            name: controller.text,
                            reminderTime: pickedTime,
                          ));
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
