// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/navigation_menu.dart';
import 'package:smart_farm/pages/calculation_page.dart';
import 'package:smart_farm/pages/home_page.dart';
import 'package:smart_farm/pages/login.dart';
import 'package:smart_farm/pages/sign_up.dart';
import 'package:smart_farm/pages/tasks/new_task.dart';
import 'package:smart_farm/pages/tasks/task_manager.dart';
import 'package:smart_farm/pages/weather_page.dart';
import 'package:smart_farm/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: FirebaseOptions(
      //apiKey: "AIzaSyDo7qdf5y-vmSXSE6x-yLH_MP7WUrHDQDM", 
      //appId: "1:601911088648:android:734743d76c086516f1a3bd", 
      //messagingSenderId: "601911088648 ", 
      //projectId: "farmmanagementsystem-f8234")
  );
  await NotificationService().init();
  await updateTaskStatuses();
  runApp(const MyApp());
}

Future<void> updateTaskStatuses() async {
  final tasksRef = FirebaseFirestore.instance.collection('tasks');
  QuerySnapshot snapshot = 
    await tasksRef.where('status', isEqualTo: 'pending').get();

  for (var doc in snapshot.docs){
    Task task = Task.fromDocument(doc);
    if (task.dateTime.isBefore(DateTime.now())){
      await tasksRef.doc(task.id).update({'status' : 'completed'});
    }
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smart farm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4CAF50)),// 0xFFA6E335
        useMaterial3: true,
      ),
      routes: {
        '/calculator': (context) => CalculationPage(),
        '/': (context) => LoginPage(),
        '/newpage': (context) => NewTaskPage(),
        '/navmenu': (context) => NavigationMenu(),
        '/taskmanager': (context) => TaskManagerPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/weather': (context) => WeatherPage(),
      },
    );
  }
}