
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'homecreen.dart';
import 'mainscreen.dart';
import 'secure_storage.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Widget page = HomePage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
   
    super.initState();
    checkLogin();
  }
  void checkLogin() async {
    var tok =  await token().gettoken();
    print(tok);
    if (tok == null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = mainscreen();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}

