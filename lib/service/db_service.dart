import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoey/app/data/task_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todoey.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE TASK (id TEXT PRIMARY KEY, task TEXT, isSelected BOOL)');
    });
  }

  newTask(TaskModel newTask) async {
    final db = await database;
    var res = await db.insert("TASK", newTask.toMap());
    // db.rawInsert("INSERT Into TASK (id,task,)"
    //     " VALUES (${newTask.id},${newTask.task})");
    return res;
  }

  deleteTask(String id) async {
    final db = await database;
    db.delete("TASK", where: "id = ?", whereArgs: [id]);
  }

  getAllTasks() async {
    final db = await database;
    var res = await db.query("TASK");
    List<TaskModel> list = res.isNotEmpty ? res.map((c) => TaskModel.fromMap(c)).toList() : [];
    return list;
  }

  getAllTaskLength() async {
    final db = await database;
    var res = await db.query("TASK");
    int listlength = res.length;
    return listlength;
  }

  updateTaskStatus(TaskModel task) async {
    final db = await database;
    TaskModel blocked = TaskModel(
      id: task.id,
      task: task.task,
      isSelected: task.isSelected,
    );
    var res = await db.update("TASK", blocked.toMap(), where: "id = ?", whereArgs: [task.id]);
    return res;
  }
}
