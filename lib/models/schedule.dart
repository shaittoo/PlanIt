import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'course.dart';

part 'schedule.g.dart';

@HiveType(typeId: 0)
class Schedule {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Course> courses;

  @HiveField(3)
  DateTime createdAt;

  Schedule({
    String? id,
    required this.name,
    List<Course>? courses,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       courses = courses ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdAt': createdAt.toIso8601String()};
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

      final hasCommonDay = course.weekDays.any(
        (day) => newCourse.weekDays.contains(day),
      );

      if (hasCommonDay) {
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

  Schedule copyWith({
    String? id,
    String? name,
    List<Course>? courses,
    DateTime? createdAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Compute tags based on the tags of the courses in the schedule
  List<String> get tags {
    final tags = <String>{};
    for (final course in courses) {
      if (course.type.isNotEmpty) {
        tags.add(course.type); // Add the course type as a tag
      }
    }
    return tags.toList();
  }
}
