import 'dart:async';

import 'package:solocoding2019_base/Database.dart';
import 'package:solocoding2019_base/models/memo.dart';

class MemosBloc {
  final _memoController = StreamController<List<Memo>>.broadcast();

  get memos => _memoController.stream;

  dispose() {
    _memoController.close();
  }

  getMemos() async {
    _memoController.sink.add(await DBProvider.db.getAllMemos());
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

  update(Memo memo) {
    DBProvider.db.updateMemo(memo);
    getMemos();
  }

  add(Memo client) {
    DBProvider.db.newMemo(client);
    getMemos();
  }

  search(String text) async {
    _memoController.sink.add(await DBProvider.db.searchMemo(text));
  }
}
