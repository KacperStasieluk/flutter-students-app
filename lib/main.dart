import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' show utf8;
import 'dart:typed_data';
//import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
      home: HomePage()
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {

  Map<String, dynamic> data = {};
  int dataLength = 0;
  bool _customTileExpanded = false;




  Future<String> getData() async {

    var response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/KacperStasieluk/flutter-students-app/main/students.json"),
        headers: {
          "Accept": "application/json"
        }
    );

    setState(() {
      print(response.statusCode);
      data = jsonDecode(response.body);
      dataLength = data["students"].length;
    });

    return "Success!";
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes).toString();
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {

  const title = "Studenci";

    List<Widget> mywidgets = [];
    for(var x = 0; x < dataLength; x++){


      print("ello");
      //html.window.localStorage["user"+x.toString()] = networkImageToBase64(data["students"][x]["img"]) as String;//Image(image: NetworkImage(data["students"][x]["img"])).toBa;
      //print(html.window.localStorage["user1"]);
      print("naura");

      List<Widget> tiles = [];
      tiles.add(Align(
        alignment: Alignment.topLeft,
          //child: Image(image: base64Decode(html.window.localStorage["user1"] as String) as ImageProvider),
          child: CachedNetworkImage(
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageUrl: data["students"][x]["img"],
          width: 50,
          height: 50,
          cacheManager: CacheManager(
              Config(
                "fluttercampus",
                stalePeriod: const Duration(seconds: 5),
                //one week cache period
              )
          ),
    ),));
      for(var y = 0; y < data["students"][x]["grades"].length; y++){
          tiles.add(ListTile(
              title: Text(data["students"][x]["grades"][y]["subject"] + ": " + data["students"][x]["grades"][y]["grade"].toString()),
          )
        );
      }

      mywidgets.add(

          ExpansionTile(
            title: Text(data["students"][x]["firstName"] + ' ' + data["students"][x]["lastName"]),
            subtitle: Text('Nr indeksu: ' + data["students"][x]["indexNumber"].toString()),
            children: tiles,
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
      );

    }

  return MaterialApp(
    title: title,
    home: Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: mywidgets,
        ),
      )

    ),
  );
  }
}

