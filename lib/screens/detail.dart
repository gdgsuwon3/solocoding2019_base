import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';
import 'package:solocoding2019_base/models/memo.dart';

class Detail extends StatelessWidget {
  final bloc = MemosBloc();

  @override
  Widget build(BuildContext context) {
    final Memo memo = ModalRoute.of(context).settings.arguments;
    final _contentController = TextEditingController();
    final _titleController = TextEditingController();
    _contentController.text = memo.content;
    _titleController.text = memo.title;
    return new Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text('작성하기'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => this.popPress(
                  context, memo, _titleController, _contentController),
            )),
        body: new Column(
          children: <Widget>[
            new TextField(
              controller: _titleController,
              maxLines: null,
              maxLengthEnforced: false,
              keyboardType: TextInputType.multiline,
            ),
            new TextField(
              controller: _contentController,
              maxLines: null,
              maxLengthEnforced: false,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ));
  }

  popPress(context, Memo memo, _titleController, _contentController) async {
    Memo newMemo = new Memo(
        id: memo.id,
        title: _titleController.text,
        content: _contentController.text,
        updatedAt: memo.updatedAt);
    this.bloc.update(newMemo);
    Navigator.pop(context, false);
  }
}
