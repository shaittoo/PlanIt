import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/create_schedule/create_schedule_screen.dart';
import '../screens/edit_schedule/edit_schedule_screen.dart';
import '../screens/schedule_detail/schedule_detail_screen.dart';

class Routes {
  static const dashboard = '/';
  static const createSchedule = '/create-schedule';
  static const editSchedule = '/edit-schedule';
  static const scheduleDetail = '/schedule-detail';

  static final Map<String, WidgetBuilder> all = {
    dashboard: (context) => const DashboardScreen(),
    createSchedule: (context) => const CreateScheduleScreen(),
    editSchedule: (context) => const EditScheduleScreen(),
    scheduleDetail: (context) => const ScheduleDetailScreen(),
  };
} 