import 'package:flutter/material.dart';
import 'package:solocoding2019_base/screens/detail.dart';
import 'package:solocoding2019_base/screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Flutter App',
        home: Home(),
        routes: <String, WidgetBuilder>{
          '/detail': (_) => Detail(),
        },
        onUnknownRoute: (RouteSettings setting) {
          return new MaterialPageRoute(builder: (context) => null);
        });
  }
}
