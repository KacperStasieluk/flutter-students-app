import 'dart:async';
import 'dart:convert';

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



  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/KacperStasieluk/flutter-students-app/main/students.json"),
        headers: {
          "Accept": "application/json"
        }
    );

    setState(() {
      data = jsonDecode(response.body);
    });

    print(data["students"]); 

    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {

  const title = "Studenci";

    List<Widget> mywidgets = [];
    for(var x = 0; x <= data.length; x++){

      String subtitles = "";
      for(var y = 0; y < data["students"][x]["grades"].length; y++){
        subtitles += "\n" + (data["students"][x]["grades"][y]["subject"] + ": " + data["students"][x]["grades"][y]["grade"].toString());
      }

      Text subtitle = Text(subtitles);

      mywidgets.add(
          ListTile(
            leading: Icon(Icons.album),
            title: Text(data["students"][x]["firstName"] + ' ' + data["students"][x]["lastName"] + ' (' + data["students"][x]["indexNumber"].toString() + ')'),
            subtitle: subtitle
          )
      );
    }

  return MaterialApp(
    title: title,
    home: Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ListView.builder(
        itemCount: mywidgets.length,
        prototypeItem: mywidgets.first,
        itemBuilder: (context, index) {
          return mywidgets[index];
        },
      ),
    ),
  );
  }
}

