import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';

import 'package:solocoding2019_base/models/memo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // data for testing
  List<Memo> list = [];
  final bloc = MemosBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future onTitlePressed(Memo item) async {
    Navigator.pushNamed(
      context,
      "/detail",
      arguments: (item),
    ).then((value) {
      bloc.getMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메모")),
      body: StreamBuilder<List<Memo>>(
        stream: bloc.memos,
        builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Memo item = snapshot.data[index];
                return Dismissible(
                  key: Key(item.id.toString()),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    bloc.delete(item.id);
                  },
                  child: ListTile(
                    title: Text(item.content),
                    leading: Text(item.id.toString()),
                    onTap: () {
                      this.onTitlePressed(item);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("메모를 작성해주세요"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bloc.add(new Memo());
        },
      ),
    );
  }
}
