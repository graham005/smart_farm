// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/pages/tasks/new_task.dart';
import 'package:smart_farm/pages/tasks/task_detail.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final tasksRef = FirebaseFirestore.instance.collection('tasks');
  Timer? timer;

  @override
  void initState(){
    super.initState();
    // Starts a timer to refresh every minute
    timer = Timer.periodic(Duration(minutes: 1), (timer){
      setState(() {});
    });
  }
  @override
  void dispose() {
    timer?.cancel(); //cancel the timer when the page is disposed 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('Task Manager')),  
        automaticallyImplyLeading: false,  
        ),
        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background.jpg'), // Add your farm background image
            fit: BoxFit.cover,
          ),
        ),
          child: StreamBuilder<QuerySnapshot>(
            stream: tasksRef.orderBy('dateTime').snapshots(), 
              builder: (context, snapshot) {
                if(!snapshot.hasData) return CircularProgressIndicator();
                List<Task> tasks = snapshot.data!.docs.map((doc){
                  return Task.fromDocument(doc);
                }).toList();
          
            //update status based on dateTime 
            tasks.forEach((task){
              if(task.dateTime.isBefore(DateTime.now()) && task.status == 'pending'){
                tasksRef.doc(task.id).update({'status': 'completed'});
              }
            });
            return ListView(
              children: tasks.map((task){
                Color statusColor = task.status == 'pending' ? Colors.red : Colors.green;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(               
                    title: Text(
                      task.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      task.status,
                      style: TextStyle(color: statusColor, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(taskId: task.id)));
                    },
                  ),
                );
              }).toList(),
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTaskPage()),
            );
          },
          child: Icon(Icons.add),
        ),
      );
  }
}