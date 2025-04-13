import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/course.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/course.dart';

class CourseItem extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseItem({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(course.color as String);
    final startTime = _formatTime(course.startTime as DateTime);
    final endTime = _formatTime(course.endTime as DateTime);
    final textStyleSecondary = TextStyle(color: Colors.grey[700]);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(color, course.name, course.type, textStyleSecondary),
              const SizedBox(height: 8),
              Text(
                '$startTime - $endTime',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(course.weekDays.join(', '), style: textStyleSecondary),
              const SizedBox(height: 8),
              _buildInfoRow(
                course.location,
                course.instructor,
                textStyleSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    Color color,
    String name,
    String type,
    TextStyle textStyle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Ensure text is fully visible
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: textStyle.copyWith(fontWeight: FontWeight.w500),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Ensure text is fully visible
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String location,
    String instructor,
    TextStyle textStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: textStyle,
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Ensure text is fully visible
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                instructor,
                style: textStyle,
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Ensure text is fully visible
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime time) => DateFormat('h:mm a').format(time);

  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }
}
