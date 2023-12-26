import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/SignUp.dart';
import 'package:flutter2/main.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool flag=false;
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
                Text("Log-in",style: TextStyle(fontSize: 70,color: Colors.black87),),
                SizedBox(height: 100,),
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
                      if (value == null || value.isEmpty || flag) {
                        return 'Please enter a valid email';
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
                      if (value == null || value.isEmpty || flag) {
                        return 'Please enter valid Password';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      final user= await _auth.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString());
                      //_auth.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString());
                      if(user!=null)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Main()));
                      else
                        setState(() {
                          flag=true;
                        });
                    }
                  },
                  child: const Text('Log_in'),
                  style: ButtonStyle(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text("Don't have a account?"),
                    InkWell(
                      child: Text("SignUp",style: TextStyle(color: Colors.blue),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                      },
                    )
                  ],),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}


