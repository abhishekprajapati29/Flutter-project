import 'package:flutter/material.dart';
import 'package:fproject/gettoken.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "flutter",
      initialRoute: '/splash',
      routes: MyRoute,
      theme: ThemeData(
          primaryColor: Colors.black, fontFamily: 'CrimsonTextRegular'),
      debugShowCheckedModeBanner: false,
    );
  }
}
