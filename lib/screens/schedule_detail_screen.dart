import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/modals/course_modal.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final String scheduleId;
  
  const ScheduleDetailScreen({
    super.key,
    required this.scheduleId,
  });

  static const List<String> timeSlots = [
    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30',
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
    '18:00'
  ];
  
  static const List<String> days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleService>(
      builder: (context, scheduleService, child) {
        final schedule = scheduleService.schedules.firstWhere(
          (s) => s.id == scheduleId,
          orElse: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule not found'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
            return Schedule(name: '');
          },
        );

        if (schedule.name.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: Text(schedule.name),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 30, 124, 255),  
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: Center(
                        child: Text(
                          'Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    ...days.map((day) => Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: timeSlots.map((time) {
                      final timeParts = time.split(':');
                      final currentHour = int.parse(timeParts[0]);
                      final currentMinute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

                      return Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Center(
                                child: Text(
                                  _formatTimeDisplay(time),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            ...days.map((day) {
                              final coursesAtTime = schedule.courses.where((course) {
                                final currentTimeInMinutes = (currentHour * 60) + currentMinute;
                                final courseStartInMinutes = (course.startTime.hour * 60) + course.startTime.minute;
                                
                                return course.weekDays.contains(day) && 
                                       currentTimeInMinutes == courseStartInMinutes;
                              }).toList();

                              if (coursesAtTime.isNotEmpty) {
                                final course = coursesAtTime.first;
                                final startMinutes = (course.startTime.hour * 60) + course.startTime.minute;
                                final endMinutes = (course.endTime.hour * 60) + course.endTime.minute;
                                final durationInMinutes = endMinutes - startMinutes;
                                final heightInBlocks = durationInMinutes / 30;

                                return Expanded(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(color: Colors.grey[300]!),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 2,
                                        right: 2,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => CourseModal(
                                                scheduleId: scheduleId,
                                                course: course,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 40.0 * heightInBlocks,
                                            decoration: BoxDecoration(
                                              color: course.color.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: course.color,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    course.name,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (heightInBlocks >= 2) ...[
                                                  Text(
                                                    course.type,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    'Prof. ${course.instructor}',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    course.location,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                                const SizedBox(height: 4),
                                                Wrap(
                                                  spacing: 4,
                                                  runSpacing: 4,
                                                  children: course.tag.split(',').map((tag) => _buildTag(tag.trim())).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.yellow,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CourseModal(
                  scheduleId: scheduleId,
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _formatTimeDisplay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? parts[1] : '00';
    
    if (hour == 12) {
      return '12:$minute PM';
    } else if (hour > 12) {
      return '${hour - 12}:$minute PM';
    } else if (hour == 0) {
      return '12:$minute AM';
    } else {
      return '$hour:$minute AM';
    }
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTagColor(tag),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'School':
        return Colors.green;
      case 'Work':
        return Colors.red;
      case 'Personal':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}