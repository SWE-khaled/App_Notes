import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/Network/hive_helper.dart';
import 'package:notes/note_screen.dart';

void main() async{
await Hive.initFlutter(); // Initialize Hive for Flutter
await Hive.openBox("Box1"); // Open a box named Box1 for storing and reading data
await Hive.openBox(HiveHelper.noteBox); // Open the notes box

    
    // Hive.box("Box1").put("key1", "Ahmed"); store ahmed in Box1
    // print(Hive.box("Box1").get("key1"));   print ahmed 

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
    );
  }
}