import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, "Expense.db"), onCreate: (db, version) {
      db.execute("CREATE TABLE messages(id TEXT, body TEXT, date TEXT)");
      db.execute("CREATE TABLE insertedMessages(id TEXT, body TEXT, date TEXT)");
      return db.execute("CREATE TABLE defaultTable(id TEXT PRIMARY KEY, note TEXT, amount TEXT, type TEXT, category TEXT, date TEXT, takenFrom TEXT)");
    }, version: 1);
  }

  static Future<void> insertName(Map<String, Object> name) async {
    final db = await DB.database();
    db.insert("allAccounts", name, conflictAlgorithm: sql.ConflictAlgorithm.ignore);
  }

  static Future<void> createTable(String tableName) async {
    final db = await DB.database();
    db.execute("CREATE TABLE $tableName(id TEXT PRIMARY KEY, note TEXT, amount TEXT, type TEXT, category TEXT, date TEXT, takenFrom TEXT)");
  }

  static Future<List> monthData(String month, String year, String tableName) async {
    final db = await DB.database();
    return await db.query(tableName, where: "id LIKE '$year-$month%'");
    // return db.query(tableName, where: "id LIKE '$year-$month%'", groupBy: 'date');
  }

  static Future<void> insertIntoTable(String tableName, Map<String, Object> data) async {
    final db = await DB.database();
    db.insert(tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List> getData(String table) async {
    final db = await DB.database();
    return db.query(table);
  }

  static Future<void> deleteTx(String id, String tableName) async {
    final db = await DB.database();
    return await db.execute("DELETE FROM $tableName WHERE ID = '$id'");
  }
  // static Future<void> updateData(String amount, String note, String category, String type) async {
  //   final db = await DB.database();
  //   db.execute(sql)
  // }
}
