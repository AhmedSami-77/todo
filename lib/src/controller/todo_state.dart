part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}
class TodoChangeNavigatorBar extends TodoState {}
class TodoChangeBottomSheet extends TodoState {}

