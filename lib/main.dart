import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/schedule_service.dart';
import 'app/app.dart';

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