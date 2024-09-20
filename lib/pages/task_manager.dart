// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/pages/new_task.dart';
import 'package:smart_farm/pages/task_detail.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final tasksRef = FirebaseFirestore.instance.collection('tasks');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('Task Manger')),    
        ),
        body: StreamBuilder<QuerySnapshot>(
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
              return ListTile(
                title: Text(task.name),
                subtitle: Text(task.status),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(taskId: task.id)));
                },
              );
            }).toList(),
          );
        }),
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