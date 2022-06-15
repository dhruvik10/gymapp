import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/exercise.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'execises.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE execises(
          id INTEGER PRIMARY KEY,
          name TEXT,
          seconds INTEGER
      )
      ''');
  }

  Future<List<Exercise>> getExecises() async {
    Database db = await instance.database;
    var execises = await db.query('execises', orderBy: 'name');
    List<Exercise> execiseList = execises.isNotEmpty
        ? execises.map((c) => Exercise.fromMap(c)).toList()
        : [];
    return execiseList;
  }

  Future<int> add(Exercise exercise) async {
    Database db = await instance.database;
    return await db.insert('execises', exercise.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('execises', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Exercise exercise) async {
    Database db = await instance.database;
    return await db.update('execises', exercise.toMap(),
        where: "id = ?", whereArgs: [exercise.id]);
  }
}
