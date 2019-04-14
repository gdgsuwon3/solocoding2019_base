import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';
import 'package:solocoding2019_base/models/memo.dart';

class Detail extends StatelessWidget {
  final bloc = MemosBloc();

  @override
  Widget build(BuildContext context) {
    final Memo memo = ModalRoute.of(context).settings.arguments;
    final _controller = TextEditingController();
    _controller.text = memo.content;

    return new Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text('작성하기'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => this.popPress(context, memo, _controller),
          )),
      body: new Container(
        color: const Color(0xFF736AB7),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller: _controller,
              maxLines: null,
              maxLengthEnforced: false,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }

  popPress(context, Memo memo, _controller) async {
    Memo newMemo = new Memo(
        id: memo.id,
        title: memo.title,
        content: _controller.text,
        updatedAt: memo.updatedAt);
    this.bloc.update(newMemo);
    Navigator.pop(context, false);
  }
}
