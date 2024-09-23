// ignore_for_file: prefer_final_fields, use_build_context_synchronously, prefer_const_constructors, avoid_print, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/services/notification_service.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  DateTime? _dateTime;
  
  void _submit() async {
    if(_formKey.currentState!.validate()&& _dateTime != null){
      _formKey.currentState!.save();

      DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add({
        'name': _name,
        'description': _description,
        'dateTime': _dateTime,
        'status': 'pending',
      });
      Task newTask = Task(
        id: docRef.id,
        name: _name,
        description: _description,
        dateTime: _dateTime!,
        status: 'pending',
      );
      // Schedule notification
      //await NotificationService().scheduleNotification(newTask);

      Navigator.pop(context);
    }else {
      print('Some error occured');
    }
  }
  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100));
    if (date != null){
      TimeOfDay? time = 
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if(time != null){
        setState(() {
          _dateTime = DateTime(
            date.year,date.month,date.day,
            time.hour,time.minute,
          );
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              //Task Name
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task Name',
                    hintText: 'Enter Task Name'
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter task name' : null,
                  onSaved: (value) => _name = value!,
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  maxLines: 5,
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Description',   
                    ),
                  onSaved: (value) => _description = value!,
                ),
              ),

              //DateTime Picker 
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: TextButton(
                  onPressed: _pickDateTime,    
                  child: Text(_dateTime == null?
                    'Select Date & Time' 
                    : _dateTime.toString(),
                    style: TextStyle(fontSize: 20, ),)
                ),
              ),

              // Submit Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit, 
                child: Text('Add Task'),)
            ],
          )
        ),
      ),
    );
  }
}