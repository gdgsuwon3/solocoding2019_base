import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';
import 'package:solocoding2019_base/models/Memo.dart';

void main() => runApp(MyApp());

// This widget is the root of your application.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  final bloc = MemosBloc();
  TextEditingController memoController = new TextEditingController();
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // set material design app
    return MaterialApp(
      title: 'solocoding2019', // application name
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MemoApp'), // app bar title
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            StreamBuilder<List<Memo>>(
              stream: bloc.clients,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
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
                          trailing: Checkbox(
                            onChanged: (bool value) {
                              bloc.blockUnblock(item);
                            },
                            value: item.deleted,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            TextField(
              controller: memoController,
              obscureText: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '메모를 입력해주세요',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            RaisedButton(
              onPressed: buttonSavePressed,
              child: const Text('저장합니다'),
            ),
          ],
        )),
      ),
    );
  }

  buttonSavePressed() async {
    Memo newMemo =
        new Memo(id: 1, title: memoController.text, content: memoController.text, createdAt: '', updatedAt: '');
    bloc.add(newMemo);
  }
}
