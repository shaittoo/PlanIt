import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';
import '../screens/modals/course_modal.dart';
import 'package:uuid/uuid.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final String _scheduleId;

  final List<String> timeSlots = [
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];

  final List<String> days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];

  @override
  void initState() {
    super.initState();
    _scheduleId = const Uuid().v4();
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
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) {
              final shouldDiscard = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text(
                        'Discard Schedule?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.blue,
                      content: const Text(
                        'You have not entered a schedule title. Do you want to discard this schedule and go back?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Discard',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (shouldDiscard == true) {
                Navigator.of(context).pop();
              }
              return;
            }

            await _saveSchedule(context);
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: TextField(
          controller: _titleController,
          autofocus: true,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Schedule Title',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _saveSchedule(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a schedule name',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                await _saveSchedule(context);
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
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
                ...days.map(
                  (day) => Expanded(
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
                  ),
                ),
              ],
            ),
          ),
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.yellow,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CourseModal(scheduleId: _scheduleId),
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
        //find the schedule or create a new one if it doesn't exist
        final schedule = scheduleService.schedules.firstWhere(
          (s) => s.id == _scheduleId,
          orElse:
              () => Schedule(
                id: _scheduleId,
                name:
                    _titleController.text.isEmpty
                        ? 'Untitled'
                        : _titleController.text,
                courses: [],
                createdAt: DateTime.now(),
              ),
        );

        return Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    formatTimeDisplay(time),
                    style: TextStyle(color: Colors.grey[700], fontSize: 11),
                  ),
                ),
              ),
              ...days.map((day) {
                final coursesAtTime =
                    schedule.courses.where((course) {
                      final currentTimeInMinutes =
                          (currentHour * 60) + currentMinute;
                      final courseStartInMinutes =
                          (course.startTime.hour * 60) +
                          course.startTime.minute;

                      return course.weekDays.contains(day) &&
                          currentTimeInMinutes == courseStartInMinutes;
                    }).toList();

                if (coursesAtTime.isNotEmpty) {
                  final course = coursesAtTime.first;
                  final startMinutes =
                      (course.startTime.hour * 60) + course.startTime.minute;
                  final endMinutes =
                      (course.endTime.hour * 60) + course.endTime.minute;
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
                                builder:
                                    (context) => CourseModal(
                                      scheduleId: _scheduleId,
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
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  if (heightInBlocks > 1) ...[
                                    Text(
                                      course.type,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      'Prof. ${course.instructor}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      softWrap: true, //text wrapping
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      course.location,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      softWrap: true, //text wrapping
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children:
                                        course.tag
                                            .split(',')
                                            .map((tag) => _buildTag(tag.trim()))
                                            .toList(),
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
      },
    );
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

  Future<void> _saveSchedule(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a schedule name',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final scheduleService = Provider.of<ScheduleService>(
      context,
      listen: false,
    );
    final schedule = Schedule(
      id: _scheduleId,
      name: _titleController.text,
      courses: [],
      createdAt: DateTime.now(),
    );

    await scheduleService.saveSchedule(schedule);
  }
}
