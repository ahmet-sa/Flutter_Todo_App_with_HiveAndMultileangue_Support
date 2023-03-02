import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app_with_hive/models/task_model.dart';
import 'package:to_do_app_with_hive/pages/home_page.dart';

import 'data/local_storeges.dart';

final localtor= GetIt.instance;
void setup(){

  localtor.registerSingleton<LocalStorage>(HiveLocalStorage());

}

Future<void> setupHive() async {

  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if(task.createdAt.day!=DateTime.now().day)
      taskBox.delete(task.id);



  }

 

}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
 await setupHive();
 setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home:  HomePage(),
    );
  }
}
