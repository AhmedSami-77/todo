import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';

part 'sql_state.dart';

class SqlCubit extends Cubit<SqlState> {
  SqlCubit() : super(SqlInitial());

  static SqlCubit get(context) => BlocProvider.of(context);
  Database? _database;
  List<Map> tasks = [];

  void createDatabase() {
    openDatabase('dataFill.db', onCreate: (database, version) {
      print('database is created');
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('the table is created ');
        emit(SqlTableCreate());
      }).catchError((error) {
        print(
            'there is some error when creating the table the error is $error');
      });
      emit(SqlCreate());
    }, onOpen: (database) {
      getFromDatabase(database).then((value) {
        tasks = value;
        emit(SqlGetData());
      });
      print('database opened');
      emit(SqlOpen());
    }, version: 1)
        .then((value) {
      _database = value;
      emit(SqlCreate());
    });
  }

  //--------------------------------------------------------------------------------------------------------------------------------
  insertDatabase({required title, required date, required time}) async {
    _database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","New")')
          .then((value) {
        print('$value inserted successfully');
        emit(SqlInsert());
        getFromDatabase(_database).then((value) {
          tasks = value;
          emit(SqlGetData());
        });
      }).catchError((error) {
        print(
            'there is some error in function insert of rawInsert the error is $error');
      });
    }).then((value) {
      emit(SqlInsert());
    }).catchError((error) {
      print(
          'there is some error in function insert of transaction the error is $error');
    });
  }

//----------------------------------------------------------------------------------------------------------------------------------
  Future<List<Map>> getFromDatabase(database) async {
    return await database!.rawQuery('SELECT * FROM tasks');
  }

//---------------------------------------------------------------------------------------------------------------------------------
  void updateDatabase({required String status, required int id}) async {
    _database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getFromDatabase(_database).then((value) {
        emit(SqlGetData());
      });
      emit(SqlUpdateData());
    });
  }void deleteDatabase({ required int id}) async {
    _database!.rawUpdate(
      'DELETE FROM tasks WHERE id = ? WHERE id = ?',
      [ id],
    ).then((value) {
      getFromDatabase(_database).then((value) {
        emit(SqlGetData());
      });
      emit(SqlDeleteData());
    });
  }
}
