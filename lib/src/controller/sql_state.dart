part of 'sql_cubit.dart';

@immutable
abstract class SqlState {}

class SqlInitial extends SqlState {}
class SqlCreate extends SqlState {}
class SqlTableCreate extends SqlState {}
class SqlOpen extends SqlState {}
class SqlInsert extends SqlState {}
class SqlGetData extends SqlState {}
class SqlDeleteData extends SqlState {}
class SqlUpdateData extends SqlState {}

