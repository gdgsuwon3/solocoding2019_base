import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';

import 'dart:math' as math;

import 'package:solocoding2019_base/models/Memo.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Memo> testMemos = [
    Memo(title: "Raouf", content: "Rahiche"),
    Memo(title: "Zaki", content: "oun"),
    Memo(title: "oussama", content: "ali"),
  ];

  final bloc = MemosBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: StreamBuilder<List<Memo>>(
        stream: bloc.clients,
        builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
          print("snapshot.hasData");
          print(snapshot.hasData);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Memo item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    bloc.delete(item.id);
                  },
                  child: ListTile(
                    title: Text(item.content),
                    leading: Text(item.id.toString()),
                    
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("ddd"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Memo rnd = testMemos[math.Random().nextInt(testMemos.length)];
          bloc.add(rnd);
        },
      ),
    );
  }
}
