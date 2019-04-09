import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // set material design app
    return new MaterialApp(
      title: 'welcome to Flutter', // application name
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'), // app bar title
        ),
        body: const Center(
          child: const Text('Hello, world'), // center text
        ),
      ),
    );
  }
}
