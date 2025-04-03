import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController _titleController = TextEditingController(text: 'Untitled');
  
  //time slots from 7:00 to 18:00
  final List<String> timeSlots = [
    '07:00', '08:00', '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00', '18:00',
  ];
  
  //days of the week
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

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
        title: IntrinsicWidth(
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Untitled',
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              //enable editing title
              _titleController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _titleController.text.length,
              );
              FocusScope.of(context).requestFocus();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //show dialog to add a course
              _showAddCourseDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //timetable header
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  //time column header
                  Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  //days row
                  Expanded(
                    child: Row(
                      children: days
                          .map((day) => Expanded(
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    day,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            //timetable grid
            ...timeSlots.map((time) => _buildTimeRow(time)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //save the schedule and return to dashboard
          _saveSchedule(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildTimeRow(String time) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          //time column
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Text(time),
          ),
          //day cells
          Expanded(
            child: Row(
              children: days
                  .map((day) => Expanded(
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          //this is where course blocks would be displayed
                          child: Container(),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Course'),
        content: const Text('This would show a form to add a course'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveSchedule(BuildContext context) {
    final scheduleService = Provider.of<ScheduleService>(context, listen: false);
    final newSchedule = Schedule(
      name: _titleController.text,
    );
    
    scheduleService.addSchedule(newSchedule);
    Navigator.of(context).pop();
  }
} 