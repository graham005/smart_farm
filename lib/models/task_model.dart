import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String name;
  String description;
  DateTime dateTime;
  String status;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.status,
  });

  factory Task.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'description': description,
      'dateTime' : dateTime,
      'status': status,
    };
  }
}