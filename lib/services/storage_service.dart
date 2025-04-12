import 'package:flutter/foundation.dart';
import 'dart:html' if (dart.library.io) 'dart:io';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule.dart';
import '../models/course.dart';
import '../services/hive_adapters.dart';

class StorageService {
  static late Box<Schedule> _scheduleBox;
  static late Box<Course> _courseBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(CourseAdapter());
    
    _scheduleBox = await Hive.openBox<Schedule>('schedules');
    _courseBox = await Hive.openBox<Course>('courses');
  }

  static Future<void> saveSchedule(Schedule schedule) async {
    await _scheduleBox.put(schedule.id, schedule);
  }

  static Future<void> saveCourse(Course course) async {
    await _courseBox.put(course.id, course);
  }

  static List<Schedule> getAllSchedules() {
    return _scheduleBox.values.toList();
  }

  static List<Course> getCoursesForSchedule(String scheduleId) {
    return _courseBox.values
        .where((course) => course.scheduleId == scheduleId)
        .toList();
  }

  static Future<void> deleteSchedule(String scheduleId) async {
    await _scheduleBox.delete(scheduleId);
    // Delete associated courses
    final coursesToDelete = _courseBox.values
        .where((course) => course.scheduleId == scheduleId)
        .map((course) => course.id);
    
    for (var courseId in coursesToDelete) {
      await _courseBox.delete(courseId);
    }
  }

  static Future<void> clear() async {
    await _scheduleBox.clear();
    await _courseBox.clear();
  }

  static Future<void> saveData(String key, dynamic value) async {
    if (kIsWeb) {
      window.localStorage[key] = jsonEncode(value);
    }
  }

  static dynamic getData(String key) {
    if (kIsWeb) {
      final data = window.localStorage[key];
      if (data != null) {
        return jsonDecode(data);
      }
    }
    return null;
  }
} 