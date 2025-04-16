import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'course.g.dart';

@HiveType(typeId: 1)
class Course {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String type;
  
  @HiveField(3)
  final TimeOfDay startTime;
  
  @HiveField(4)
  final TimeOfDay endTime;
  
  @HiveField(5)
  final List<String> weekDays;
  
  @HiveField(6)
  final String location;
  
  @HiveField(7)
  final String instructor;
  
  @HiveField(8)
  final Color color;
  
  @HiveField(9)
  final String scheduleId;
  
  @HiveField(10)
  final String tag;

  @HiveField(11)
  final String deliveryMode; // 'online' or 'face-to-face'

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
    required this.tag,
    this.deliveryMode = 'face-to-face',
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'endTimeHour': endTime.hour,
      'endTimeMinute': endTime.minute,
      'weekDays': weekDays.join(','),
      'location': location,
      'instructor': instructor,
      'color': color.value.toString(),
      'scheduleId': scheduleId,
      'tag': tag,
      'deliveryMode': deliveryMode,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      startTime: TimeOfDay(
        hour: map['startTimeHour'],
        minute: map['startTimeMinute'],
      ),
      endTime: TimeOfDay(
        hour: map['endTimeHour'],
        minute: map['endTimeMinute'],
      ),
      weekDays: (map['weekDays'] as String).split(','),
      location: map['location'],
      instructor: map['instructor'],
      color: Color(int.parse(map['color'])),
      scheduleId: map['scheduleId'],
      tag: map['tag'],
      deliveryMode: map['deliveryMode'] ?? 'face-to-face',
    );
  }

  bool isScheduledFor(String day, TimeOfDay time) {
    if (!weekDays.contains(day)) return false;
    
    int timeInMinutes = time.hour * 60 + time.minute;
    int startInMinutes = startTime.hour * 60 + startTime.minute;
    int endInMinutes = endTime.hour * 60 + endTime.minute;
    
    return timeInMinutes >= startInMinutes && timeInMinutes < endInMinutes;
  }

  int get blockHeight {
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    return ((endMinutes - startMinutes) / 30).ceil();
  }
} 