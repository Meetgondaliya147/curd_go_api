
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // data();
  }
  final dio = Dio();
  Future getHttp() async {
    final response = await dio.get('https://dummyjson.com/products');
    Map m=response.data;
    return m;
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: Text("Products"),backgroundColor: Colors.teal),
      body:FutureBuilder(
        future: getHttp(),
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
