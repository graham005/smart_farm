// ignore_for_file: prefer_const_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            //showToast(message: "Successfully signed out");
          }, 
          icon: Icon(Icons.logout))
          ],
      ),
      body: Center(
        child: Text("Welcome to Home "),
      ),
    );
  }
}