import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Helper extends StatefulWidget {
  final String id;

  const Helper(this.id, {Key? key}) : super(key: key);

  @override
  State<Helper> createState() => _HelperState();
}

class _HelperState extends State<Helper> {
  String _id="";
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _store=FirebaseFirestore.instance;
  FirebaseDatabase _datare=FirebaseDatabase.instance;
  Map<String,dynamic> _map={};
  List<dynamic> _arr=[];
  void initState()
  {
    super.initState();
    _id = widget.id;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              height: 550,
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
                                      child: Image.network(snapshot.child('picture').value.toString(),fit: BoxFit.fill,)
                                  ),
                                  Container(
                                      height: 30,
                                      child: Text("${snapshot.child('Caption').value.toString()}",style: TextStyle(fontSize:20),)
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: (){},icon:Icon(Icons.thumb_up)),
                                Text("${snapshot.child("Likes").value.toString()}"),
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
    );
  }
}
