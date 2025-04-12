import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../services/schedule_service.dart';

class CreateCourseModal extends StatefulWidget {
  final String scheduleId;

  const CreateCourseModal({
    super.key,
    required this.scheduleId,
  });

  @override
  State<CreateCourseModal> createState() => _CreateCourseModalState();
}

class _CreateCourseModalState extends State<CreateCourseModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseTypeController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String selectedColor = 'FFE082'; // Default to the first color (yellow)
  TimeOfDay startTime = const TimeOfDay(hour: 11, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 13, minute: 0);
  Set<String> selectedDays = {'M', 'Th'};
  String selectedTag = 'School';
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

  OverlayEntry? _currentToast;

  @override
  void dispose() {
    _titleController.dispose();
    _courseTypeController.dispose();
    _instructorController.dispose();
    _locationController.dispose();
    _removeToast();
    super.dispose();
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'New Event Title',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tag',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTagSelector(),
                        const SizedBox(height: 12),
                        const Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildColorGrid(),
                        const SizedBox(height: 12),
                        const Text(
                          'Week Frequency',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildWeekDaySelector(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Time',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTimeButton(startTime, true),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'End Time',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTimeButton(endTime, false),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _courseTypeController,
                          decoration: InputDecoration(
                            labelText: 'Course Type',
                            hintText: 'Course Type (e.g. Lecture, Lab)',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _instructorController,
                          decoration: InputDecoration(
                            labelText: 'Instructor',
                            hintText: 'Instructor Name',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: 'Location',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  bool _isTimeWithinBounds(TimeOfDay time) {
    final timeInMinutes = time.hour * 60 + time.minute;
    final earliestTime = 6 * 60; 
    final latestTime = 20 * 60; 
    return timeInMinutes >= earliestTime && timeInMinutes <= latestTime;
  }

  Widget _buildTimeButton(TimeOfDay time, bool isStart) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        
        if (newTime != null) {
          if (!_isTimeWithinBounds(newTime)) {
            _showToast('Please select a time between 6:00 AM and 8:00 PM');
            return;
          }

          if (!isStart && newTime.hour * 60 + newTime.minute <= startTime.hour * 60 + startTime.minute) {
            _showToast('End time must be after start time');
            return;
          }

          if (isStart && newTime.hour * 60 + newTime.minute >= endTime.hour * 60 + endTime.minute) {
            _showToast('Start time must be before end time');
            return;
          }

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

  void _showToast(String message) {
    _removeToast();

    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 50,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    _currentToast = overlayEntry;
    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      _removeToast();
    });
  }

  void _removeToast() {
    _currentToast?.remove();
    _currentToast = null;
  }

  void _saveCourse() {
    if (_titleController.text.isEmpty) {
      _showToast('Please enter a course title');
      return;
    }

    if (selectedDays.isEmpty) {
      _showToast('Please select at least one day');
      return;
    }

    if (!_isTimeWithinBounds(startTime) || !_isTimeWithinBounds(endTime)) {
      _showToast('Course times must be between 6:00 AM and 8:00 PM');
      return;
    }

    final startTimeMinutes = startTime.hour * 60 + startTime.minute;
    final endTimeMinutes = endTime.hour * 60 + endTime.minute;
    
    if (endTimeMinutes <= startTimeMinutes) {
      _showToast('End time must be after start time');
      return;
    }

    final course = Course(
      name: _titleController.text,
      type: _courseTypeController.text.isEmpty ? 'Lec' : _courseTypeController.text,
      startTime: startTime,
      endTime: endTime,
      weekDays: selectedDays.toList(),
      location: _locationController.text.isEmpty ? 'TBA' : _locationController.text,
      instructor: _instructorController.text.isEmpty ? 'TBA' : _instructorController.text,
      color: Color(int.parse('FF$selectedColor', radix: 16)),
      scheduleId: widget.scheduleId,
      tag: selectedTag,
    );

    final scheduleService = Provider.of<ScheduleService>(context, listen: false);
    scheduleService.addCourseToSchedule(widget.scheduleId, course);
    Navigator.pop(context);
  }
} 