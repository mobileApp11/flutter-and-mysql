import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File _file;
  bool x = true;

  _opencamera() async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      _file = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  _opengallery() async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      _file = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  String image;

  Future uploadimg() async {
    if (_file == null) {
      print("select image");
    } else {
      String based64 = base64Encode(_file.readAsBytesSync());
      String imgname = _file.path.split("/").last;
      var data = {
        "imagename": imgname,
        "image64": based64,
      };
      var url = "http://10.0.2.2/uploadimage/uploadimage.php";
      var respons = await http.post(url, body: data);
      var responsbody = jsonDecode(respons.body);
      if (responsbody['status'] == "sucess") {
        print(responsbody);
        image = responsbody['ximage'];
        print("true");
      } else {
        print("false");
      }
    }
  }
  
  showdiloag() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _opencamera();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "open camera",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _opengallery();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "open gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload image'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showdiloag();
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      "Select image",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  uploadimg();
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      "Upload image",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                child:
                    _file == null ? Text("no select  img") : Image.file(_file),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    x = !x;
                  });
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      "Get image from mysql",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
              x
                  ? Container(
                      height: 200,
                      child: image == null
                          ? Text("null")
                          : Image.network(
                              "http://10.0.2.2/uploadimage/img/${image}"))
                  : Text(""),
            ],
          )
        ],
      ),
    );
  }
}
