import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tellme/src/controller/sql_cubit.dart';
import 'package:tellme/src/controller/todo_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = TodoCubit.get(context);
    return SafeArea(
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocConsumer<SqlCubit, SqlState>(
            listener: (context, state) {},
            builder: (context, state) {
              var sqlCubit = SqlCubit.get(context);
              return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: Text(cubit.screenName[cubit.currentIndex]),
                ),
                body: cubit.screen[cubit.currentIndex],
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        sqlCubit.insertDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text);
                        cubit.changeBottomSheet(
                            isShow: false, icon: Icons.edit);

                        Navigator.pop(context);
                        titleController.clear();
                        dateController.clear();
                        timeController.clear();
                      }
                    } else {
                      scaffoldKey.currentState!
                          .showBottomSheet(
                            (context) => Container(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'please enter the title';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text('task title'),
                                          prefixIcon: Icon(Icons.title)),
                                    ),
                                    SizedBox(height: 10,),
                                    TextFormField(
                                      controller: timeController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'please enter the time';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        }).catchError((error) {
                                          print(error.toString());
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text('Time'),
                                          prefixIcon: Icon(Icons.watch_later)),
                                    ),
                                    SizedBox(height: 10,),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'please enter the date';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2030-01-01'),
                                        ).then((value) {
                                          dateController.text =
                                              '${value!.year}-${value.month}-${value.day}';
                                        }).catchError((error) {
                                          print(error.toString());
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text('Data'),
                                          prefixIcon: Icon(Icons.calendar_month_outlined)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .closed
                          .then((value) {
                        cubit.changeBottomSheet(
                            isShow: false, icon: Icons.edit);
                        titleController.clear();
                        dateController.clear();
                        titleController.clear();
                      });
                      cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                    }
                  },
                  child: Icon(cubit.fabIcon),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.task), label: 'Tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.done), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_rounded), label: 'Archived'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
