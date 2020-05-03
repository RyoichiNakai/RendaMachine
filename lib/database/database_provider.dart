import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rendamachine/database/database_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

//コマンド一覧
// /data/data/com.expample.flutterapp/databases/
// run-as com.example.flutterapp cat databases/RendaMachine_10.db > /sdcard/mode_10.db
// adb pull /sdcard/mode_10.db /Users/ryoichinakai/WorkSpace
/// データベース毎にこのクラスを継承したProviderを実装する
abstract class DatabaseProvider {
  Database db;
  String get databaseName;
  String get tableName;

  void init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, databaseName);
    //deleteDatabase(path);
    // openDatabaseメソッドを使用することでDBインスタンスを取得することができます。
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version){
        newDb.execute(
            """
               CREATE TABLE $tableName(
                "id" INTEGER PRIMARY KEY,
                "username" TEXT,
                "score" INTEGER
               )
            """
        );
      },
    );
  }

  //追加
  Future<void> insertScore(User user) async{
    print(user.toMap());
    await db.insert(
      tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //中に入っているデータを受け取る
  Future<List<Map<String, dynamic>>> getScore() async{
    final List<Map<String, dynamic>> maps
    = await db.query(tableName, orderBy: "score DESC");
    return maps;
  }

  //検索用
  Future<List<Map<String, dynamic>>> getName(String name) async{
    final List<Map<String, dynamic>> maps
    = await db.query(tableName, where:"username = ?", whereArgs:[name]);
    return maps;
  }
}

class DbProvider10 extends DatabaseProvider {
  @override
  String get databaseName => 'RendaMachine_10.db';

  @override
  String get tableName => 'mode10sScore';
}

class DbProvider60 extends DatabaseProvider {
  @override
  String get databaseName => 'RendaMachine_60.db';

  @override
  String get tableName => 'mode60sScore';
}

class DbProviderEndless extends DatabaseProvider {
  @override
  String get databaseName => 'RendaMachine_endless.db';

  @override
  String get tableName => 'modeEndlessScore';
}
