import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/Onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await scheduleDailyReminder();

  runApp(const HabitApp());
}

Future<void> scheduleDailyReminder() async
{
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'habit_reminder_channel',
    'Habit Reminders',
    channelDescription: 'Daily habit reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Habit Hero Reminder',
    'Don’t forget to complete your habits today! 💪',
    _nextInstanceOfEightAM(),
    platformDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfEightAM() 
{
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

class HabitApp extends StatefulWidget {
  const HabitApp({super.key});

  @override
  State<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends State<HabitApp> {
  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadGender();
  }

  Future<void> _loadGender() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gender = prefs.getString('gender');
    });
  }

  ThemeData _getTheme() {
    if (_gender == "male") {
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.amberAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.amberAccent,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[900],
          shadowColor: Colors.amberAccent.withOpacity(0.7),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      );
    } else if (_gender == "female") {
      // Wonder Woman Theme 💜🔥
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF8C00FF), // Neon Purple
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8C00FF),
          secondary: Color(0xFFFF4081), // Neon Pink
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF4081),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC107), // Neon Gold
          foregroundColor: Colors.black,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFF4081),
          shadowColor: const Color(0xFFFFC107).withOpacity(0.7),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      );
    } else {
      return ThemeData.light();
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Habit Hero',
      debugShowCheckedModeBanner: false,
      theme: _getTheme(),
      home: _gender == null ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}





















