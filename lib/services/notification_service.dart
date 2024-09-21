// ignore_for_file: deprecated_member_use

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:timezone/timezone.dart' as tz ;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(Task task) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode, 
      'Task Reminder', 
      'It\'s time for "${task.name}"', 
      tz.TZDateTime.from(task.dateTime, tz.local), 
      const NotificationDetails(
        android:  AndroidNotificationDetails(
          'task_channel', 
          'Task Notification',
          channelDescription: 'Channel for task reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ), 
      androidAllowWhileIdle: true,
      payload: task.id,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}