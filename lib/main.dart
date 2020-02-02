import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/model/hive_controller.dart';
import 'package:flutter_test_task/ui/global_container.dart';

import 'bloc/home/home_bloc.dart';

void main() async {
  await HiveController.initialSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black,
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.black,
        ),
      ),
      home: BlocProvider(
        child: GlobalContainer(),
        create: (context) {
          return HomeBloc()..add(LoadData());
        },
      ),
    );
  }
}
