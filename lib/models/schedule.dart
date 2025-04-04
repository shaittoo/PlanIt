import 'package:uuid/uuid.dart';
import 'course.dart';

class Schedule {
  final String id;
  String name;
  List<Course> courses;
  DateTime createdAt;

  Schedule({
    String? id,
    required this.name,
    List<Course>? courses,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        courses = courses ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  bool hasConflict(Course newCourse) {
    for (final course in courses) {
      if (course.id == newCourse.id) continue;
      
      //check if courses share any weekdays
      final hasCommonDay = course.weekDays
          .any((day) => newCourse.weekDays.contains(day));
      
      if (hasCommonDay) {
        //check time overlap
        final newStart = newCourse.startTime;
        final newEnd = newCourse.endTime;
        final existingStart = course.startTime;
        final existingEnd = course.endTime;

        if (!(newEnd.isBefore(existingStart) || 
            newStart.isAfter(existingEnd))) {
          return true;
        }
      }
    }
    return false;
  }
}