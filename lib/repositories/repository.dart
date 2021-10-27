// ignore_for_file: unnecessary_null_comparison

import 'package:sqflite/sqflite.dart';
import 'package:todoapp/repositories/database_connection.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    //intial database
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;
//check if databasi is exist or not
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    // ignore: recursive_getters
    return database;
  }

  //inserting data into table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //read data from table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  //read data by id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

//update data from table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

//delete data from table
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id=$itemId");
  }

//read data from table bu column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return connection
        .query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }
}
