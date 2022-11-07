import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool _customTileExpanded = false;
  File file = File('/cache/cache.txt');

  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/KacperStasieluk/flutter-students-app/main/students.json"),
        headers: {
          "Accept": "application/json"
        }
    );

    setState(() {
      print(response.statusCode);
      if (response.statusCode == 200)
        {
          data = jsonDecode(response.body);
        }
      else
        {
          file.readAsString().then((String content) =>
          {
            data = jsonDecode(content)
          });
        }
    });

    file = await file.writeAsString(data.toString());

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
    for(var x = 0; x < data["students"].length; x++){

      List<Widget> tiles = [];
      tiles.add(Align(
        alignment: Alignment.topLeft,
          child: CachedNetworkImage(
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageUrl: 'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png',
          width: 50,
          height: 50,
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

