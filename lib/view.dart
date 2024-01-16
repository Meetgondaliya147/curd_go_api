import 'dart:convert';
import 'package:curd_go_api/data.dart';
import 'package:dio/dio.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class view extends StatefulWidget {
  const view({super.key});

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {


  Widget build(BuildContext context) {
    data p=ModalRoute.of(context)!.settings.arguments as data;

    Future getHttp() async {
      var url = Uri.https('dummyjson.com', 'products/${p.id}');
      var response = await http.get(url);
      Map l = jsonDecode(response.body);
      List m = l['id'];
      print("mmm${m}");
      return m;
    }
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: Text("${p.title}"),backgroundColor:Colors.teal ),
      body: FutureBuilder(future: getHttp(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done){
        List s=p.images!;
          return Column(children: [
            GFCarousel(
              items: s.map(
                    (url) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Image.network(
                          url,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 900,
                      ),
                    ),
                  );
                },
              ).toList(),
              onPageChanged: (index) {
                  index;
              },
            ),
            SizedBox(height: 40,),
            Text("${p.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            ListTile(title: Text("${p.description}",style: TextStyle(fontSize: 20),)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("RS : ${p.price}",style: TextStyle(fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Text("OFF : ${p.discountPercentage} % ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              GFRating(
                value: p.rating,
                color: Colors.teal,
                onChanged: (value) {
                  p.rating = value;
                },
              ),
            Text("    ${p.rating}",style: TextStyle(fontSize: 20),),
            ],)

          ],);
        }else{
          return Center(child: CircularProgressIndicator(color: Colors.teal,));
        }
      },),
    );
  }
}
