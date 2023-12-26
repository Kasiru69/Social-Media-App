import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/login.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _arr=[],_list=[];
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _store=FirebaseFirestore.instance;
  FirebaseDatabase _datare=FirebaseDatabase.instance;
  Map<String,dynamic> _map={};
  Map<dynamic,dynamic> _map2={};
  String _id="";
  bool _flag=false;
  void initState(){
    _id=_auth.currentUser!.uid;
    print(_id);
    //print(_datare.ref().onValue);
    help().then((List<dynamic> arr){
      setState((){
        _arr=arr;
        for(String it in _arr){
          Name(it);
        }
        print(_list);
        print(_arr);
      });
    });
    //print(_arr);
  }
  Future<List<dynamic>> help()async{
    late List<dynamic> arr=[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();
    if (snapshot.exists) {
      snapshot.children.forEach((child) {
        //print(child.value.runtimeType);
        arr.add(child.key);
      });
    }
    return arr;
  }
  Future<String> fetchmapuserdetails(String id)async{
    DocumentSnapshot snapshot=await _store.collection("Users").doc(id).get();
    final data = snapshot.data() as Map<String, dynamic>;
    //print(data['name']);
    return data['name'];
  }
  Future<void> Name(String id)async{
    String tmp=await fetchmapuserdetails(id);
    print(tmp);
    setState(() {
      _list.add(tmp);
      _map2[id]=tmp;
    });
    print(_map2);
  }
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
              Container(
                height:MediaQuery.of(context).size.height-72,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(itemCount:_arr.length,itemBuilder: (context,index){

                  return Container(
                    height: 450,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
                    child:FirebaseAnimatedList(scrollDirection:Axis.horizontal,query:_datare.ref(_arr[index]),itemBuilder:(context,snapshot,animation,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child:Container(
                              height: 450,
                              decoration: BoxDecoration(border: Border.all()),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text(_map2[snapshot.child('userid').value.toString()]),
                                  Text("  ${_map2[snapshot.child('userid').value.toString()]}",style: TextStyle(fontSize: 25),),
                                  Container(height: 350,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: 300,
                                              width: MediaQuery.of(context).size.width,
                                              child: (snapshot.child('picture').value.toString()!=null)?Image.network(snapshot.child('picture').value.toString(),fit: BoxFit.fill,):CircularProgressIndicator()
                                          ),
                                        ),
                                        Container(
                                            height: 30,
                                            child: Text("  Caption : ${snapshot.child('Caption').value.toString()}",style: TextStyle(fontSize:20),)
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              int count=int.parse(snapshot.child("Likes").value.toString());
                                              print(snapshot.child("set").value.runtimeType);
                                              String str=snapshot.child('userid').value.toString();
                                              Set<dynamic> fuckme={FirebaseAuth.instance.currentUser!.uid};
                                              List<dynamic> sett=[];
                                              if(snapshot.child("set").value == Null) sett=fuckme.toList();
                                              else{
                                                if (snapshot.child("set").value is List<dynamic>) {
                                                  sett = snapshot.child("set").value as List<dynamic>;
                                                }
                                              }
                                              Set<dynamic> set=sett.toSet();
                                              set.add(FirebaseAuth.instance.currentUser!.uid);
                                              List<dynamic> arr=set.toList();
                                              print(set);
                                              FirebaseDatabase.instance.ref(snapshot.child('userid').value.toString()).child(snapshot.key as String).update(
                                                  {
                                                    "Likes": arr.length ,
                                                    "set": arr
                                                  }
                                              );
                                            },icon:Icon(Icons.thumb_up)),
                                            Text("${snapshot.child("Likes").value.toString()}"),
                                          ],
                                        ),
                                        IconButton(onPressed: (){},icon:Icon(Icons.comment)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    }),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
