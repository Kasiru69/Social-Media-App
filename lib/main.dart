import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/Add.dart';
import 'package:flutter2/Home.dart';
import 'package:flutter2/Profile.dart';
import 'package:flutter2/Search.dart';
import 'package:flutter2/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        name: "name-here",
    options: FirebaseOptions(apiKey: "AIzaSyCxQlVIsW3xniaDpCFynk4qQDPWj2HwaFY",
        authDomain: "fir-2-3e077.firebaseapp.com",
        databaseURL: "https://fir-2-3e077-default-rtdb.firebaseio.com",
        projectId: "fir-2-3e077",
        storageBucket: "fir-2-3e077.appspot.com",
        messagingSenderId: "66311812105",
        appId: "1:66311812105:web:993708d47c76562759f4d8",
        measurementId: "G-JXE8E62MX0")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light
      ),
      home: FirebaseAuth.instance.currentUser==null?login():Main(),
      //home: Main(),
    );
  }
}
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String _val='Hello';
  int _index=0;
  List<Widget> arr=[Home(),Search(),Add(),Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: arr[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: (_index==0)?Colors.blue:Colors.black87,),label: " ",),
          BottomNavigationBarItem(icon: Icon(Icons.search,color: (_index==1)?Colors.blue:Colors.black87,),label: " ",),
          BottomNavigationBarItem(icon: Icon(Icons.add,color: (_index==2)?Colors.blue:Colors.black87,),label: " ",),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: (_index==3)?Colors.blue:Colors.black87),label: " ")
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        selectedItemColor: Colors.white,
        onTap: (index){
          setState(() {
            _index=index;
          });
        },
      ),
    );
  }
}
