import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solocoding2019_base/models/Memo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Memo ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "content TEXT,"
          "createdAt TEXT"
          ")");
    });
  }

  newMemo(Memo newMemo) async {
    final db = await database;
    //get the biggest id in the table
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Memo");
    // int id = table.first["id"];
    //insert to the table using the new id

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var raw = await db.rawInsert(
        "INSERT Into Memo (title,content,createdAt)"
        " VALUES (?,?,?)",
        [newMemo.title, newMemo.content, formattedDate]);
    return raw;
  }

  blockOrUnblock(Memo memo) async {
    final db = await database;
    Memo createdAt = Memo(
        id: memo.id,
        title: memo.title,
        content: memo.content,
        createdAt: memo.createdAt);
    var res = await db.update("Memo", createdAt.toMap(),
        where: "id = ?", whereArgs: [memo.id]);
    return res;
  }

  updateMemo(Memo newMemo) async {
    final db = await database;
    var res = await db.update("Memo", newMemo.toMap(),
        where: "id = ?", whereArgs: [newMemo.id]);
    return res;
  }

  getMemo(int id) async {
    final db = await database;
    var res = await db.query("Memo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Memo.fromMap(res.first) : null;
  }

  Future<List<Memo>> getBlockedMemos() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Memo WHERE createdAt=1");
    var res = await db.query("Memo", where: "createdAt = ? ", whereArgs: [1]);

    List<Memo> list =
        res.isNotEmpty ? res.map((c) => Memo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Memo>> getAllMemos() async {
    final db = await database;
    var res = await db.query("Memo");
    List<Memo> list =
        res.isNotEmpty ? res.map((c) => Memo.fromMap(c)).toList() : [];
    print("getAllMemos");
    print(list);
    return list;
  }

  deleteMemo(int id) async {
    final db = await database;
    return db.delete("Memo", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Clinet");
  }
}
