import 'package:aspire_training/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
   runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      primarySwatch: Colors.lightBlue,
    ),
    home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
        actions: <Widget>[
        ],
      ),
      body: Profile(),
    ),
  ));
}

