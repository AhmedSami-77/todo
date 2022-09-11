import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/sql_cubit.dart';
import '../controller/todo_cubit.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SqlCubit, SqlState>(
      listener: (context, state) {},
      builder: (context, state) {

        var sqlCubit = SqlCubit.get(context);
        return ListView.builder(
          itemBuilder: (context, index) {
            return sqlCubit.tasks[index]['status'] == 'done'
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey[300]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 40,
                              child: Text(sqlCubit.tasks[index]['time'])),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  sqlCubit.tasks[index]['title'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  sqlCubit.tasks[index]['date'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          IconButton(
                              onPressed: () {
                                sqlCubit.updateDatabase(
                                    status: 'done',
                                    id: sqlCubit.tasks[index]['id']);

                              },
                              icon: const Icon(
                                Icons.done_outline_sharp,
                                color: Colors.teal,
                              )),
                          IconButton(
                              onPressed: () {
                                sqlCubit.updateDatabase(
                                    status: 'archived',
                                    id: sqlCubit.tasks[index]['id']);

                              },
                              icon: const Icon(
                                Icons.archive_rounded,
                                color: Colors.black45,
                              )),
                        ],
                      ),
                    ),
                  )
                : Container();
          },
          itemCount: sqlCubit.tasks.length,
        );
      },
    );
  }
}
