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
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "메모",
    style: new TextStyle(color: Colors.white),
  );
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  _HomeState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        bloc.search(_searchQuery.text);
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
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
      appBar: AppBar(title: appBarTitle, actions: <Widget>[
        new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "검색...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            })
      ]),
      body: StreamBuilder<List<Memo>>(
          stream: bloc.memos,
          builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Memo item = snapshot.data[index];
                  var updatedAt = DateTime.parse(item.updatedAt);
                  var year = updatedAt.year.toString();
                  var month = updatedAt.month.toString();
                  var day = updatedAt.day.toString();

                  if (snapshot.hasData && this._searchText == "") {
                    return Dismissible(
                      key: Key(item.id.toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        bloc.delete(item.id);
                      },
                      child: new Column(
                        children: <Widget>[
                          new Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[Text('$year년$month월')]),
                          ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.content),
                            leading: Text('$day일'),
                            onTap: () {
                              this.onTitlePressed(item);
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    return ChildItem(item);
                  }
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bloc.add(new Memo());
        },
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "검색하기",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      bloc.getMemos();
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final Memo memo;
  ChildItem(this.memo);
  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Text(this.memo.title));
  }
}
