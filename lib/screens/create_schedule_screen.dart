import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/schedule.dart';
import '../../models/course.dart';
import '../../services/schedule_service.dart';
import '../screens/modals/course_modal.dart';
import 'package:uuid/uuid.dart';
import '../../models/course.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

// Constants outside class
const List<String> timeSlots = [
  '06:00', '06:30', '07:00', '07:30', '08:00', '08:30',
  '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
  '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
  '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
  '18:00'
];
const List<String> days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];

const TextStyle headerStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 11,
);
const TextStyle timeTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 11,
);

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final String _scheduleId;

  @override
  void initState() {
    super.initState();
    _scheduleId = const Uuid().v4();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schedule = Schedule(id: _scheduleId, name: _titleController.text);
      Provider.of<ScheduleService>(context, listen: false).addSchedule(schedule);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String formatTimeDisplay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    if (hour == 0) return '12:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return hour > 12 ? '${hour - 12}:$minute PM' : '$hour:$minute AM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: TextField(
          controller: _titleController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Untitled',
            hintStyle: timeTextStyle.copyWith(fontWeight: FontWeight.w500, color: Colors.grey[500]),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _saveSchedule(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveSchedule(context),
            child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 60,
                  height: 30,
                  child: Center(child: Text('Time', style: headerStyle)),
                ),
                ...days.map((day) => Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Center(child: Text(day, style: headerStyle)),
                  ),
                )),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CourseModal(
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
    final currentMinute = int.parse(timeParts[1]);

    return Consumer<ScheduleService>(
      builder: (context, scheduleService, _) {
        final schedule = scheduleService.schedules.firstWhere(
          (s) => s.id == _scheduleId,
          orElse: () => Schedule(id: _scheduleId, name: _titleController.text),
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
                child: Center(child: Text(formatTimeDisplay(time), style: timeTextStyle)),
              ),
              ...days.map((day) {
                final currentTimeInMinutes = currentHour * 60 + currentMinute;
                Course? course;
                try {
                  course = schedule.courses.firstWhere(
                    (c) => c.weekDays.contains(day) &&
                           currentTimeInMinutes == (c.startTime.hour * 60 + c.startTime.minute),
                  );
                } catch (_) {
                  course = null;
                }

                if (course != null) {
                  final startMinutes = course.startTime.hour * 60 + course.startTime.minute;
                  final endMinutes = course.endTime.hour * 60 + course.endTime.minute;
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
                                builder: (context) => CourseModal(
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (heightInBlocks > 1) ...[
                                    Text(
                                      course.type,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Prof. ${course.instructor}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      course.location,
                                      style: const TextStyle(
                                        fontSize: 10,
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

  Future<void> _saveSchedule(BuildContext context) async {
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
      name: _titleController.text.trim(),
      courses: [],
      createdAt: DateTime.now(),
    );
    
    await scheduleService.saveSchedule(schedule);
    Navigator.of(context).pop();
  }
}
