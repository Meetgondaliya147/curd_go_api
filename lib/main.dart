
import 'dart:math';

import 'package:curd_go_api/view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'data.dart';

void main(){
  runApp(
      MaterialApp(
        routes: {
          "demo":(context) => demo(),
          "view":(context) => view()
        },
        home: demo(),debugShowCheckedModeBanner: false,));
}
class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  bool search=false;
  String str="";
  final dio = Dio();
  Future getHttp(String str) async {
    dynamic response;
    if(str==""){
       response = await dio.get('https://dummyjson.com/products');
    }else{
       response = await dio.get('https://dummyjson.com/products/search?q=$str');
    }
    Map m=response.data;
    return m;
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar:(search)?AppBar(title: TextField(onChanged: (value) {
        setState(() {
          str=value;
        });
      },decoration: InputDecoration(hintText: 'Search Product')),actions: [
        IconButton(onPressed: () {
          setState(() {
            search=!search;
            Navigator.pushNamed(context, "demo");
          });
        }, icon: Icon(Icons.cancel_outlined))
      ],backgroundColor: Colors.teal):
      AppBar(title: Text("Products"),actions: [
        IconButton(onPressed: () {
          setState(() {
            search=!search;
          });
        }, icon: Icon(Icons.search))
      ],backgroundColor: Colors.teal),
      body:FutureBuilder(
        future: getHttp("$str"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map m = snapshot.data;
            List l = m['products'];

            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                data s = data.fromJson(l[index]);
                return Card(
                  color: Colors.teal.shade100,
                  child: ListTile(onTap: () {
                    Navigator.pushNamed(context,"view",arguments: s);
                  },

                    title: Text(
                      "${s.title}",
                    ),
                    leading: Image.network("${s.thumbnail}",height:75,width: 75,),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
