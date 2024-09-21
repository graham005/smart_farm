// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/pages/tasks/edit_task.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;
  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final tasksRef = FirebaseFirestore.instance.collection('tasks');
  Task? task;

  @override
  void _fetchTask()async{
    DocumentSnapshot doc = await tasksRef.doc(widget.taskId).get();
    setState(() {
      task = Task.fromDocument(doc);
    });
  }

  void _deleteTask(){
    tasksRef.doc(task!.id).delete();
    Navigator.pop(context);
  }

  void _editTask(){
    if(task!.status == 'pending'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTaskPage(task: task!)
          ),
      ).then((_) => _fetchTask());
    }
  }
  @override
  Widget build(BuildContext context) {
    if(task == null) return Scaffold(body: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title : Text(task!.name),
        actions: [
          if(task!.status == 'pending')
            IconButton(onPressed: _editTask, icon: Icon(Icons.edit)),
            IconButton(onPressed: _deleteTask, icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description : ${task!.description}'),
            SizedBox(height: 10),
            Text('Date & Time: ${task!.dateTime}'),
            SizedBox(height: 10),
            Text('Status: ${task!.status}'),
          ],
        ),
      ),
    );
  }
}