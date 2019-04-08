import 'dart:async';

import 'package:solocoding2019_base/Database.dart';
import 'package:solocoding2019_base/models/Memo.dart';

class MemosBloc {
  final _clientController = StreamController<List<Memo>>.broadcast();

  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getMemos() async {
    _clientController.sink.add(await DBProvider.db.getAllMemos());
  }

  MemosBloc() {
    getMemos();
  }

  blockUnblock(Memo client) {
    DBProvider.db.blockOrUnblock(client);
    getMemos();
  }

  delete(int id) {
    DBProvider.db.deleteMemo(id);
    getMemos();
  }

  add(Memo client) {
    DBProvider.db.newMemo(client);
    getMemos();
  }
}