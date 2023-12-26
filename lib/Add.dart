import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/Profile.dart';
import 'package:flutter2/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  File? image;
  FirebaseDatabase dataref=FirebaseDatabase.instance;
  TextEditingController text=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("New Post",style:TextStyle(fontSize: 50),),
            InkWell(
              onTap: ()async{
                XFile? selectedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
                print(selectedimage!.path);
                if(selectedimage!=null)
                  {
                    File convert=File(selectedimage!.path);
                    setState(() {
                      image=convert;
                    });
                  }
              },
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: (image!=null)?Image.file(image!,fit: BoxFit.fill,):Center(child: Text("Tap the screen to add an image",style: TextStyle(fontSize: 25),),),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              height: 50,
              child: TextFormField(
                controller: text,
                style: TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 2.0),
                ),labelText: "Write a caption"),
              ),
            ),
            ElevatedButton(
              onPressed: ()async {
                String id=FirebaseAuth.instance.currentUser!.uid;
                UploadTask ut=FirebaseStorage.instance.ref().child(id).child(Uuid().v1()).putFile(image!);
                TaskSnapshot ts=await ut;
                String url=await ts.ref.getDownloadURL();
                dataref.ref(id).child(Uuid().v1()).set({
                  "picture":url,
                  "Caption":text.text.toString(),
                  "Likes":0,
                  "userid":id,
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Main()));
              },
              child: const Text('Post'),
              style: ButtonStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
