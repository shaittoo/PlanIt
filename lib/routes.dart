import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_schedule_screen.dart';

import 'screens/schedule_detail_screen.dart';

class Routes {
  static const dashboard = '/';
  static const createSchedule = '/create-schedule';
  static const scheduleDetail = '/schedule-detail';

  static Map<String, Widget Function(BuildContext)> get all => {
    dashboard: (context) => const DashboardScreen(),
    createSchedule: (context) => const CreateScheduleScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case scheduleDetail:
        final scheduleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ScheduleDetailScreen(scheduleId: scheduleId),
        );
      default:
        return null;
    }
  }
} 