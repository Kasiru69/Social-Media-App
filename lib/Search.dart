import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/helper.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search=TextEditingController();
  bool _flag=false;
  bool _flag2=false;
  int _id=-1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: (){
            setState(() {
              _flag=false;
              _flag2=false;
            });
          },
        ),
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: search,
          decoration: InputDecoration(labelText: 'Search for a user'),
          onChanged: (String _){
            setState(() {
              _flag=true;
            });
          },
        ),
      ),
      body: (_flag)?FutureBuilder(
        future: FirebaseFirestore.instance.collection("Users").where('name',isGreaterThanOrEqualTo: search.text.toString()).get(),
        builder: (context,snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
            return (!_flag2)?ListView.builder(itemCount:(snapshot.data! as dynamic).docs.length,itemBuilder:(context,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:InkWell(
                  onTap: (){
                    setState(() {
                      print(index);
                      _id=index;
                      _flag2=true;
                    });
                  },
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black87))),
                    child: Text((snapshot.data! as dynamic).docs[index]['name'],style: TextStyle(fontSize: 20),),
                  ),
                )
              );
            }):Helper((snapshot.data! as dynamic).docs[_id]['userid']);
        },
      ):Center(child: Text("Post"),),
    );
  }
}
