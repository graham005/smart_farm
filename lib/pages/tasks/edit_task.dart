// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/models/task_model.dart';
import 'package:smart_farm/services/notification_service.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  DateTime? _dateTime;

  @override
  void initState(){
    super.initState();
    _name = widget.task.name;
    _description = widget.task.description;
    _dateTime = widget.task.dateTime;
  }

  // Class to handle submiting
  void _submit() async{
    if(_formKey.currentState!.validate()&& _dateTime != null){
      _formKey.currentState!.save();

      await FirebaseFirestore.instance.collection('tasks').doc(widget.task.id).update({
        'name' : _name,
        'description': _description,
        'dateTime' : _dateTime,
      });

      // Reschedule notification
      Task updatedTask = Task(
        id: widget.task.id, 
        name: _name, 
        description: _description, 
        dateTime: _dateTime!, 
        status: 'pending'
      );
      await NotificationService().scheduleNotification(updatedTask);

      Navigator.pop(context);
    }else{
      print('Some error occured');
    }
  }

  // Class to change the date 
  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context, 
      initialDate: _dateTime!,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
    );
    if (date != null){
      TimeOfDay? time = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(_dateTime!)
      );
    if(time != null){
      setState(() {
        _dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
    }
  }
  @override
  Widget build(BuildContext context) {
    // If the task's status is completed
    if (widget.task.status == 'completed'){
      return Scaffold(
        appBar: AppBar(title: Text('Cannot Edit Completed Task')),
        body: Center(child: Text('Completed tasks cannot be edited'),),
      );
    }
    return Scaffold(
            appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color(0xFF4CAF50),
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
                child: Text('Update Task'),)
            ],
          )
        ),
      ),
    );
  }
}