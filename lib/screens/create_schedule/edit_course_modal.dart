import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../services/schedule_service.dart';

class EditCourseModal extends StatefulWidget {
  final Course course;
  final String scheduleId;

  const EditCourseModal({
    super.key,
    required this.course,
    required this.scheduleId,
  });

  @override
  State<EditCourseModal> createState() => _EditCourseModalState();
}

class _EditCourseModalState extends State<EditCourseModal> {
  late TextEditingController _titleController;
  late TextEditingController _courseTypeController;
  late TextEditingController _instructorController;
  late TextEditingController _locationController;
  
  late String selectedColor;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late Set<String> selectedDays;
  late String selectedTag;
  final List<String> tagOptions = ['School', 'Work', 'Personal'];

  final List<Color> colorOptions = [
    const Color(0xFFFFE082), 
    const Color(0xFFB2FF59), 
    const Color(0xFFFF8A65), 
    const Color(0xFF80DEEA), 
    const Color(0xFFCE93D8), 
    const Color(0xFFAED581), 
    const Color(0xFFFFB74D), 
    const Color(0xFFF8BBD0), 
    const Color(0xFFEF5350), 
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.name);
    _courseTypeController = TextEditingController(text: widget.course.type);
    _instructorController = TextEditingController(text: widget.course.instructor);
    _locationController = TextEditingController(text: widget.course.location);
    
    selectedColor = widget.course.color.value.toRadixString(16).substring(2);
    startTime = widget.course.startTime;
    endTime = widget.course.endTime;
    selectedDays = Set.from(widget.course.weekDays);
    selectedTag = widget.course.tag;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: MediaQuery.of(context).size.height * 0.1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Course',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tag',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTagSelector(),
              const SizedBox(height: 16),
              const Text(
                'Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildColorGrid(),
              const SizedBox(height: 16),
              const Text(
                'Week Days',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildWeekDaySelector(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildTimeButton(startTime, true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildTimeButton(endTime, false),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _courseTypeController,
                decoration: InputDecoration(
                  labelText: 'Course Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _instructorController,
                decoration: InputDecoration(
                  labelText: 'Instructor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Course'),
                            content: const Text('Are you sure you want to delete this course?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final scheduleService = Provider.of<ScheduleService>(context, listen: false);
                                  scheduleService.deleteCourse(widget.scheduleId, widget.course.id);
                                  Navigator.pop(context);
                                  Navigator.pop(context); 
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a course name')),
                          );
                          return;
                        }
                        final updatedCourse = Course(
                          id: widget.course.id,
                          name: _titleController.text,
                          type: _courseTypeController.text,
                          startTime: startTime,
                          endTime: endTime,
                          weekDays: selectedDays.toList(),
                          location: _locationController.text,
                          instructor: _instructorController.text,
                          color: Color(int.parse('FF$selectedColor', radix: 16)),
                          scheduleId: widget.scheduleId,
                          tag: selectedTag,
                        );
                        final scheduleService = Provider.of<ScheduleService>(context, listen: false);
                        scheduleService.updateCourse(widget.scheduleId, updatedCourse);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagSelector() {
    return Row(
      children: tagOptions.map((tag) {
        final isSelected = selectedTag == tag;
        Color tagColor;
        switch (tag) {
          case 'School':
            tagColor = Colors.green;
            break;
          case 'Work':
            tagColor = Colors.red;
            break;
          default:
            tagColor = Colors.blue;
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTag = tag;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? tagColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? tagColor : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          mainAxisExtent: 24,
        ),
        itemCount: colorOptions.length,
        itemBuilder: (context, index) {
          final color = colorOptions[index];
          final colorHex = color.value.toRadixString(16).substring(2);
          final isSelected = selectedColor == colorHex;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = colorHex;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekDaySelector() {
    final days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        final isSelected = selectedDays.contains(day);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(day);
              } else {
                selectedDays.add(day);
              }
            });
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.grey,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeButton(TimeOfDay time, bool isStart) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        
        if (newTime != null) {
          setState(() {
            if (isStart) {
              startTime = newTime;
            } else {
              endTime = newTime;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time.format(context),
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              time.period == DayPeriod.am ? 'AM' : 'PM',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
} 