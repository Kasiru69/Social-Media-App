import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/login.dart';
import 'package:flutter2/main.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _store=FirebaseFirestore.instance;
  FirebaseDatabase _datare=FirebaseDatabase.instance;
  Map<String,dynamic> _map={};
  List<dynamic> _arr=[];
  String _id="";
  int _c=0;
  @override
  void initState()
  {
    _id=_auth.currentUser!.uid;
    fetchmapuserdetails().then((Map<String,dynamic> map){
      setState(() {
        _map=map;
      });
    });
    help().then((List<dynamic> arr){
      setState(() {
        _arr=arr;
        print(_arr.length);
      });
    });
    super.initState();
  }
  Future<List<dynamic>> help()async{
    late List<dynamic> arr=[];
    final ref = FirebaseDatabase.instance.ref(_id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      snapshot.children.forEach((child) {
        arr.add(child.value);
      });
      //print(arr);
    }
    return arr;
  }
  Future<Map<String,dynamic>> fetchmapuserdetails()async{
    DocumentSnapshot snapshot=await _store.collection("Users").doc(_id).get();
    final data = snapshot.data() as Map<String, dynamic>;
    return data;
  }
  //List<String> arr=["Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo","Halo"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/images_ah.png"),
                fit: BoxFit.fill,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 50,
              child: IconButton(onPressed: (){_auth.signOut(); Navigator.push(context, MaterialPageRoute(builder: (context) => const login()));},icon: Icon(Icons.logout),),
              ),
              Text("${_map['name']!=null?_map['name']:" "}",style: TextStyle(fontSize: 30),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("${_arr.length}",style: TextStyle(fontSize: 20)),
                      Text("Posts",style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Column(
                    children: [
                      Text("0",style: TextStyle(fontSize: 20)),
                      Text("Followers",style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Column(
                    children: [
                      Text("0",style: TextStyle(fontSize: 20),),
                      Text("Following",style: TextStyle(fontSize: 20))
                    ],
                  ),
                ],
              ),
              Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
                child: (_arr.length!=0)?FirebaseAnimatedList(query:_datare.ref(_id),itemBuilder:(context,snapshot,animation,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child:Container(
                        height: 400,
                        decoration: BoxDecoration(border: Border(bottom:BorderSide(color: Colors.black87))),
                        child: Column(
                          children: [
                            Container(height: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: (snapshot.child('picture').value.toString()!=null)?Image.network(snapshot.child('picture').value.toString(),fit: BoxFit.fill,):CircularProgressIndicator()
                                ),
                                Container(
                                  height: 30,
                                    child: Text("Caption : ${snapshot.child('Caption').value.toString()}",style: TextStyle(fontSize:20,),)
                                )
                              ],
                            ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                children: [
                                  Icon(Icons.thumb_up),
                                  Text("${snapshot.child("Likes").value.toString()}"),
                                ],
                                ),
                                IconButton(onPressed: (){},icon:Icon(Icons.comment)),
                                IconButton(onPressed: (){
                                  setState(() {
                                    FirebaseDatabase.instance.ref(_id).child(snapshot.key.toString()).remove().then((value) => null);
                                  });
                                  //FirebaseDatabase.instance.ref(_id).child(snapshot.key.toString()).remove();
                                }, icon: Icon(Icons.delete))
                              ],
                            )
                          ],
                        ),
                      )
                    ),
                  );
                }):Center(child: Text("No Posts",style: TextStyle(fontSize: 50),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
