import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/schedule_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final scheduleService = ScheduleService();
  await scheduleService.initDatabase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => scheduleService,
      child: const PlanItApp(),
    ),
  );
}

class PlanItApp extends StatelessWidget {
  const PlanItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: Routes.dashboard,
      routes: Routes.all,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
