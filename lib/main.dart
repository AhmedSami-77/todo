import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tellme/src/controller/bloc_observer.dart';
import 'package:tellme/src/controller/sql_cubit.dart';
import 'package:tellme/src/controller/todo_cubit.dart';
import 'package:tellme/src/screens/home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SqlCubit()..createDatabase(),
        ),
        BlocProvider(
          create: (context) => TodoCubit(),
        ),
      ],
      child: MaterialApp(
          title: 'Tell me',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen()
      ),
    );
  }
}
