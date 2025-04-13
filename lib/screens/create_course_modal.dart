// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/course.dart';
// import '../../services/schedule_service.dart';

// class CreateCourseModal extends StatefulWidget {
//   final String scheduleId;

//   const CreateCourseModal({
//     super.key,
//     required this.scheduleId,
//   });

//   @override
//   State<CreateCourseModal> createState() => _CreateCourseModalState();
// }

// class _CreateCourseModalState extends State<CreateCourseModal> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _courseTypeController = TextEditingController();
//   final TextEditingController _instructorController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
  
//   String selectedColor = 'FFE082'; // Default to the first color (yellow)
//   TimeOfDay startTime = const TimeOfDay(hour: 11, minute: 30);
//   TimeOfDay endTime = const TimeOfDay(hour: 13, minute: 0);
//   Set<String> selectedDays = {'M', 'Th'};
//   String selectedTag = 'School';
//   final List<String> tagOptions = ['School', 'Work', 'Personal'];

//   final List<Color> colorOptions = [
//     const Color(0xFFFFE082), 
//     const Color(0xFFB2FF59),
//     const Color(0xFFFF8A65),
//     const Color(0xFF80DEEA), 
//     const Color(0xFFCE93D8), 
//     const Color(0xFFAED581), 
//     const Color(0xFFFFB74D), 
//     const Color(0xFFF8BBD0), 
//     const Color(0xFFEF5350), 
//   ];

//   OverlayEntry? _currentToast;

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _courseTypeController.dispose();
//     _instructorController.dispose();
//     _locationController.dispose();
//     _removeToast();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: MediaQuery.of(context).size.height * 0.1,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: SingleChildScrollView(
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.8,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Create',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                       icon: const Icon(Icons.close, size: 20),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Flexible(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextField(
//                           controller: _titleController,
//                           decoration: InputDecoration(
//                             hintText: 'New Event Title',
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Tag',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _buildTagSelector(),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Color',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _buildColorGrid(),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Week Frequency',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _buildWeekDaySelector(),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'Start Time',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   _buildTimeButton(startTime, true),
//                                 ],
//                               ),
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               child: Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'End Time',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   _buildTimeButton(endTime, false),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _courseTypeController,
//                           decoration: InputDecoration(
//                             labelText: 'Course Type',
//                             hintText: 'Course Type (e.g. Lecture, Lab)',
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _instructorController,
//                           decoration: InputDecoration(
//                             labelText: 'Instructor',
//                             hintText: 'Instructor Name',
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _locationController,
//                           decoration: InputDecoration(
//                             labelText: 'Location',
//                             hintText: 'Location',
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Cancel'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _saveCourse,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Save'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTagSelector() {
//     return Row(
//       children: tagOptions.map((tag) {
//         final isSelected = selectedTag == tag;
//         Color tagColor;
//         switch (tag) {
//           case 'School':
//             tagColor = Colors.green;
//             break;
//           case 'Work':
//             tagColor = Colors.red;
//             break;
//           default:
//             tagColor = Colors.blue;
//         }

//         return Padding(
//           padding: const EdgeInsets.only(right: 8),
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 selectedTag = tag;
//               });
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: isSelected ? tagColor : Colors.transparent,
//                 border: Border.all(
//                   color: isSelected ? tagColor : Colors.grey,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 tag,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.grey,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildColorGrid() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 9,
//           mainAxisSpacing: 6,
//           crossAxisSpacing: 6,
//           mainAxisExtent: 24,
//         ),
//         itemCount: colorOptions.length,
//         itemBuilder: (context, index) {
//           final color = colorOptions[index];
//           final colorHex = color.value.toRadixString(16).substring(2); 
//           final isSelected = selectedColor == colorHex;
          
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 selectedColor = colorHex;
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: isSelected
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     )
//                   : null,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildWeekDaySelector() {
//     final days = ['M', 'T', 'W', 'Th', 'F', 'Sat'];
    
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: days.map((day) {
//         final isSelected = selectedDays.contains(day);
        
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isSelected) {
//                 selectedDays.remove(day);
//               } else {
//                 selectedDays.add(day);
//               }
//             });
//           },
//           child: Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.amber : Colors.transparent,
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(
//                 color: isSelected ? Colors.amber : Colors.grey,
//               ),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               day,
//               style: TextStyle(
//                 color: isSelected ? Colors.black : Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   bool _isTimeWithinBounds(TimeOfDay time) {
//     final timeInMinutes = time.hour * 60 + time.minute;
//     final earliestTime = 6 * 60; 
//     final latestTime = 20 * 60; 
//     return timeInMinutes >= earliestTime && timeInMinutes <= latestTime;
//   }

//   Widget _buildTimeButton(TimeOfDay time, bool isStart) {
//     return InkWell(
//       onTap: () async {
//         final TimeOfDay? newTime = await showTimePicker(
//           context: context,
//           initialTime: time,
//         );
        
//         if (newTime != null) {
//           if (!_isTimeWithinBounds(newTime)) {
//             _showToast('Please select a time between 6:00 AM and 8:00 PM');
//             return;
//           }

//           if (!isStart && newTime.hour * 60 + newTime.minute <= startTime.hour * 60 + startTime.minute) {
//             _showToast('End time must be after start time');
//             return;
//           }

//           if (isStart && newTime.hour * 60 + newTime.minute >= endTime.hour * 60 + endTime.minute) {
//             _showToast('Start time must be before end time');
//             return;
//           }

//           setState(() {
//             if (isStart) {
//               startTime = newTime;
//             } else {
//               endTime = newTime;
//             }
//           });
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               time.format(context),
//               style: const TextStyle(fontSize: 14),
//             ),
//             Text(
//               time.period == DayPeriod.am ? 'AM' : 'PM',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showToast(String message) {
//     _removeToast();

//     OverlayState? overlayState = Overlay.of(context);
//     late OverlayEntry overlayEntry;
    
//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).viewInsets.top + 50,
//         left: 32,
//         right: 32,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.red.shade600,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.error_outline,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     message,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     _currentToast = overlayEntry;
//     overlayState.insert(overlayEntry);

//     Future.delayed(const Duration(seconds: 2), () {
//       _removeToast();
//     });
//   }

//   void _removeToast() {
//     _currentToast?.remove();
//     _currentToast = null;
//   }

//   void _saveCourse() {
//     if (_titleController.text.isEmpty) {
//       _showToast('Please enter a course title');
//       return;
//     }

//     if (selectedDays.isEmpty) {
//       _showToast('Please select at least one day');
//       return;
//     }

//     if (!_isTimeWithinBounds(startTime) || !_isTimeWithinBounds(endTime)) {
//       _showToast('Course times must be between 6:00 AM and 8:00 PM');
//       return;
//     }

//     final startTimeMinutes = startTime.hour * 60 + startTime.minute;
//     final endTimeMinutes = endTime.hour * 60 + endTime.minute;
    
//     if (endTimeMinutes <= startTimeMinutes) {
//       _showToast('End time must be after start time');
//       return;
//     }

//     final course = Course(
//       name: _titleController.text,
//       type: _courseTypeController.text.isEmpty ? 'Lec' : _courseTypeController.text,
//       startTime: startTime,
//       endTime: endTime,
//       weekDays: selectedDays.toList(),
//       location: _locationController.text.isEmpty ? 'TBA' : _locationController.text,
//       instructor: _instructorController.text.isEmpty ? 'TBA' : _instructorController.text,
//       color: Color(int.parse('FF$selectedColor', radix: 16)),
//       scheduleId: widget.scheduleId,
//       tag: selectedTag,
//     );

//     final scheduleService = Provider.of<ScheduleService>(context, listen: false);
//     scheduleService.addCourseToSchedule(widget.scheduleId, course);
//     Navigator.pop(context);
//   }
// } 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../services/schedule_service.dart';

class CreateCourseModal extends StatefulWidget {
  final String scheduleId;

  const CreateCourseModal({super.key, required this.scheduleId});

  @override
  State<CreateCourseModal> createState() => _CreateCourseModalState();
}

class _CreateCourseModalState extends State<CreateCourseModal> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _instructorController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> tagOptions = ['School', 'Work', 'Personal'];
  final Map<String, Color> tagColors = {
    'School': Colors.green,
    'Work': Colors.red,
    'Personal': Colors.blue,
  };

  final List<Color> colorOptions = [
    Color(0xFFFFE082), Color(0xFFB2FF59), Color(0xFFFF8A65),
    Color(0xFF80DEEA), Color(0xFFCE93D8), Color(0xFFAED581),
    Color(0xFFFFB74D), Color(0xFFF8BBD0), Color(0xFFEF5350),
  ];

  final List<String> weekDays = ['M', 'T', 'W', 'Th', 'F', 'Sat'];

  String selectedColor = 'FFE082';
  Set<String> selectedDays = {'M', 'Th'};
  TimeOfDay startTime = const TimeOfDay(hour: 11, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 13, minute: 0);
  String selectedTag = 'School';

  OverlayEntry? _toast;

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildTextField(_titleController, hint: 'New Event Title'),
                  _buildLabel('Tag'),
                  _buildTagSelector(),
                  _buildLabel('Color'),
                  _buildColorGrid(),
                  _buildLabel('Week Frequency'),
                  _buildWeekDaySelector(),
                  const SizedBox(height: 12),
                  _buildTimePickers(),
                  _buildTextField(_typeController, label: 'Course Type', hint: 'Lecture, Lab, etc.'),
                  _buildTextField(_instructorController, label: 'Instructor', hint: 'Instructor Name'),
                  _buildTextField(_locationController, label: 'Location', hint: 'Room/Building'),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}


  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('Create', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      IconButton(
        icon: const Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, {String? label, required String hint}) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  Widget _buildTagSelector() => Row(
    children: tagOptions.map((tag) {
      final isSelected = tag == selectedTag;
      final tagColor = tagColors[tag]!;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: () => setState(() => selectedTag = tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? tagColor : Colors.transparent,
              border: Border.all(color: isSelected ? tagColor : Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(tag, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildColorGrid() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 9, mainAxisSpacing: 6, crossAxisSpacing: 6, mainAxisExtent: 24,
    ),
    itemCount: colorOptions.length,
    itemBuilder: (context, index) {
      final color = colorOptions[index];
      final hex = color.value.toRadixString(16).substring(2);
      final selected = selectedColor == hex;
      return GestureDetector(
        onTap: () => setState(() => selectedColor = hex),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
        ),
      );
    },
  );

  Widget _buildWeekDaySelector() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: weekDays.map((day) {
      final selected = selectedDays.contains(day);
      return GestureDetector(
        onTap: () => setState(() => selected ? selectedDays.remove(day) : selectedDays.add(day)),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: selected ? Colors.amber : Colors.grey),
          ),
          child: Text(day, style: TextStyle(color: selected ? Colors.black : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      );
    }).toList(),
  );

  Widget _buildTimePickers() => Row(
    children: [
      Expanded(child: _buildTimeSection('Start Time', startTime, true)),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey)),
      Expanded(child: _buildTimeSection('End Time', endTime, false)),
    ],
  );

  Widget _buildTimeSection(String label, TimeOfDay time, bool isStart) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      _buildTimeButton(time, isStart),
    ],
  );

  Widget _buildTimeButton(TimeOfDay time, bool isStart) => InkWell(
    onTap: () async {
      final TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
      if (picked == null) return;
      final minutes = (t) => t.hour * 60 + t.minute;

      if (!_isTimeWithinBounds(picked)) {
        _showToast('Select time between 6:00 AM and 8:00 PM');
        return;
      }

      if (!isStart && minutes(picked) <= minutes(startTime)) {
        _showToast('End time must be after start time');
        return;
      }

      if (isStart && minutes(picked) >= minutes(endTime)) {
        _showToast('Start time must be before end time');
        return;
      }

      setState(() => isStart ? startTime = picked : endTime = picked);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time.format(context), style: const TextStyle(fontSize: 14)),
          Text(time.period == DayPeriod.am ? 'AM' : 'PM', style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );

  Widget _buildActionButtons() => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
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
          ),
          child: const Text('Save'),
        ),
      ),
    ],
  );

  void _saveCourse() {
    if (_titleController.text.isEmpty) return _showToast('Please enter a course title');
    if (selectedDays.isEmpty) return _showToast('Please select at least one day');
    if (!_isTimeWithinBounds(startTime) || !_isTimeWithinBounds(endTime)) return _showToast('Course times must be between 6:00 AM and 8:00 PM');
    if (endTime.hour * 60 + endTime.minute <= startTime.hour * 60 + startTime.minute) return _showToast('End time must be after start time');

    final course = Course(
      name: _titleController.text,
      type: _typeController.text.isEmpty ? 'Lec' : _typeController.text,
      instructor: _instructorController.text,
      location: _locationController.text.isEmpty ? 'TBA' : _locationController.text,
      startTime: startTime,
      endTime: endTime,
      weekDays: selectedDays.toList(),
      color: Color(int.parse('FF$selectedColor', radix: 16)),
      scheduleId: widget.scheduleId,
      tag: selectedTag,
    );

    Provider.of<ScheduleService>(context, listen: false).addCourseToSchedule(widget.scheduleId, course);
    Navigator.pop(context);
  }

  bool _isTimeWithinBounds(TimeOfDay t) => t.hour >= 6 && t.hour < 20;

  void _showToast(String message) {
    _removeToast();
    final overlay = Overlay.of(context);
    _toast = OverlayEntry(
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14))),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(_toast!);
    Future.delayed(const Duration(seconds: 2), _removeToast);
  }

  void _removeToast() {
    _toast?.remove();
    _toast = null;
  }
}
