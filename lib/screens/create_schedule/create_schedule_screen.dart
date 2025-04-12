import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';
import '../../screens/create_schedule/create_course_modal.dart';
import 'package:uuid/uuid.dart';
import '../../models/course.dart';
import '../../screens/create_schedule/edit_course_modal.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final String _scheduleId;
  
  // Time slots from 6:00 to 18:00
  final List<String> timeSlots = [
    '06:00', '06:30',  // 6:00 AM, 6:30 AM
    '07:00', '07:30',  // 7:00 AM, 7:30 AM
    '08:00', '08:30',  // 8:00 AM, 8:30 AM
    '09:00', '09:30',  // 9:00 AM, 9:30 AM
    '10:00', '10:30',  // 10:00 AM, 10:30 AM
    '11:00', '11:30',  // 11:00 AM, 11:30 AM
    '12:00', '12:30',  // 12:00 PM, 12:30 PM
    '13:00', '13:30',  // 1:00 PM, 1:30 PM
    '14:00', '14:30',  // 2:00 PM, 2:30 PM
    '15:00', '15:30',  // 3:00 PM, 3:30 PM
    '16:00', '16:30',  // 4:00 PM, 4:30 PM
    '17:00', '17:30',  // 5:00 PM, 5:30 PM
    '18:00', '18:30',  // 6:00 PM, 6:30 PM
    '19:00', '19:30',  // 7:00 PM, 7:30 PM
    '20:00',           // 8:00 PM
  ];
  
  // Days of the week
  final List<String> days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];

  @override
  void initState() {
    super.initState();
    _scheduleId = const Uuid().v4();
    // Initialize the schedule in the service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schedule = Schedule(
        id: _scheduleId,
        name: _titleController.text,
      );
      Provider.of<ScheduleService>(context, listen: false).addSchedule(schedule);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Untitled',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                _saveSchedule(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header row with days
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
                  height: 30,  // Changed from 40 to 30
                  child: Center(
                    child: Text(
                      'Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        fontSize: 11,  // Reduced font size
                      ),
                    ),
                  ),
                ),
                ...days.map((day) => Expanded(
                  child: Container(
                    height: 30,  // Changed from 40 to 30
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
                          fontSize: 11,  // Reduced font size
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          // Time grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: timeSlots.map((time) => _buildTimeRow(time)).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateCourseModal(
              scheduleId: _scheduleId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTimeRow(String time) {
    final timeParts = time.split(':');
    final currentHour = int.parse(timeParts[0]);
    final currentMinute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

    // Convert 24-hour format to 12-hour format for display
    String formatTimeDisplay(String time) {
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

    return Consumer<ScheduleService>(
      builder: (context, scheduleService, child) {
        final schedule = scheduleService.schedules.firstWhere(
          (s) => s.id == _scheduleId,
          orElse: () => Schedule(id: _scheduleId, name: _titleController.text)
        );

        return Container(
          height: 40,  // Changed from 60 to 40
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            children: [
              // Time column
              SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    formatTimeDisplay(time),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 11,  // Reduced font size
                    ),
                  ),
                ),
              ),
              // Day columns
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditCourseModal(
                                  course: course,
                                  scheduleId: _scheduleId,
                                ),
                              );
                            },
                            child: Container(
                              height: 40.0 * heightInBlocks,  // Changed from 60 to 40
                              decoration: BoxDecoration(
                                color: course.color.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6),  // Reduced border radius
                                border: Border.all(
                                  color: course.color,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(3),  // Reduced padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 11,  // Reduced font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (heightInBlocks > 1) ...[
                                    Text(
                                      course.type,
                                      style: const TextStyle(
                                        fontSize: 10,  // Reduced font size
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Prof. ${course.instructor}',
                                      style: const TextStyle(
                                        fontSize: 10,  // Reduced font size
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      course.location,
                                      style: const TextStyle(
                                        fontSize: 10,  // Reduced font size
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
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
      },
    );
  }

  void _saveSchedule(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a schedule name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final scheduleService = Provider.of<ScheduleService>(context, listen: false);
    final schedule = Schedule(
      id: _scheduleId,
      name: _titleController.text,
      courses: [], // Courses are already saved individually
      createdAt: DateTime.now(),
    );
    
    await scheduleService.saveSchedule(schedule);
    Navigator.of(context).pop();
  }
} 