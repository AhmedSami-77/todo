import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tellme/src/modules/new_tasks.dart';

import '../modules/archives_tasks.dart';
import '../modules/done_tasks.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List screenName = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoChangeNavigatorBar());
  }

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(TodoChangeBottomSheet());
  }
}
