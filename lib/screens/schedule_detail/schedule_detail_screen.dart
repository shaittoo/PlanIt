import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final String scheduleId;
  
  const ScheduleDetailScreen({
    super.key,
    required this.scheduleId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleService>(
      builder: (context, scheduleService, child) {
        final schedule = scheduleService.schedules.firstWhere((s) => s.id == scheduleId);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(schedule.name),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Schedule Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Schedule Name: ${schedule.name}'),
                Text('Created: ${schedule.createdAt.toString().substring(0, 10)}'),
                Text('Number of Courses: ${schedule.courses.length}'),
              ],
            ),
          ),
        );
      },
    );
  }
}