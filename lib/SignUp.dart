import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/main.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController name=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _store=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/image2.png"),
                    fit: BoxFit.fill,
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome",style: TextStyle(fontSize: 70,color: Colors.black87),),
                  SizedBox(height: 75,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: email,
                      style: TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 2.0),
                      ),labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: password,
                      style: TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 2.0),
                      ),labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: name,
                      style: TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 2.0),
                      ),labelText: "UserName"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Username';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ()async {
                      if (_formKey.currentState!.validate()) {
                        final user= await _auth.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString());

                        _store.collection("Users").doc(_auth.currentUser!.uid).set({
                          "name":name.text.toString(),
                          "email":email.text.toString(),
                          "password":password.text.toString(),
                          "userid":FirebaseAuth.instance.currentUser!.uid.toString()
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Main()));
                      }
                    },
                    child: const Text('Register'),
                    style: ButtonStyle(),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
