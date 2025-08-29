import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'models/task_model.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'pages/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // initialize notifications plugin
  await StorageService().init(); // initialize storage
  runApp(TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskModel>(
      create: (_) => TaskModel()..loadTasksFromStorage(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TaskMaster',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          fontFamily: 'Poppins',
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskMaster',
      home: const SplashScreen(),
    );
  }
}
