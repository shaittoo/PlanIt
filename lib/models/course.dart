import 'package:uuid/uuid.dart';

class Course {
  final String id;
  String name;
  String type;
  DateTime startTime;
  DateTime endTime;
  List<String> weekDays;
  String location;
  String instructor;
  String color;
  String scheduleId;
  int dayIndex; 
  int startHour;
  int endHour; 

  Course({
    String? id,
    required this.name,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.weekDays,
    required this.location,
    required this.instructor,
    required this.color,
    required this.scheduleId,
    required this.dayIndex,
    required this.startHour,
    required this.endHour,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'weekDays': weekDays.join(','),
      'location': location,
      'instructor': instructor,
      'color': color,
      'scheduleId': scheduleId,
      'dayIndex': dayIndex,
      'startHour': startHour,
      'endHour': endHour,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      weekDays: map['weekDays'].split(','),
      location: map['location'],
      instructor: map['instructor'],
      color: map['color'],
      scheduleId: map['scheduleId'],
      dayIndex: map['dayIndex'],
      startHour: map['startHour'],
      endHour: map['endHour'],
    );
  }
} 