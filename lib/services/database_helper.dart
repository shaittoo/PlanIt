import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DatabaseHelper {
  static Database? _database;
  static SharedPreferences? _prefs;

  static Future<void> initStorage() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      _database = await _initDatabase();
    }
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'planit.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schedules(
        id TEXT PRIMARY KEY,
        name TEXT,
        createdAt TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE courses(
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        startTimeHour INTEGER,
        startTimeMinute INTEGER,
        endTimeHour INTEGER,
        endTimeMinute INTEGER,
        weekDays TEXT,
        location TEXT,
        instructor TEXT,
        color INTEGER,
        scheduleId TEXT,
        tag TEXT
      )
    ''');
  }

  static Future<void> saveSchedule(Map<String, dynamic> schedule) async {
    if (kIsWeb) {
      final schedules = await getSchedules();
      final index = schedules.indexWhere((s) => s['id'] == schedule['id']);
      if (index != -1) {
        schedules[index] = schedule;
      } else {
        schedules.add(schedule);
      }
      await _prefs!.setString('schedules', jsonEncode(schedules));
    } else {
      await _database!.insert(
        'schedules',
        schedule,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> saveCourse(Map<String, dynamic> course) async {
    if (kIsWeb) {
      final courses = await getCourses();
      final index = courses.indexWhere((c) => c['id'] == course['id']);
      if (index != -1) {
        courses[index] = course;
      } else {
        courses.add(course);
      }
      await _prefs!.setString('courses', jsonEncode(courses));
    } else {
      await _database!.insert(
        'courses',
        course,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getSchedules() async {
    if (kIsWeb) {
      final schedulesJson = _prefs!.getString('schedules') ?? '[]';
      return List<Map<String, dynamic>>.from(
        jsonDecode(schedulesJson).map((x) => Map<String, dynamic>.from(x))
      );
    } else {
      return await _database!.query('schedules');
    }
  }

  static Future<List<Map<String, dynamic>>> getCourses({String? scheduleId}) async {
    if (kIsWeb) {
      final coursesJson = _prefs!.getString('courses') ?? '[]';
      final courses = List<Map<String, dynamic>>.from(
        jsonDecode(coursesJson).map((x) => Map<String, dynamic>.from(x))
      );
      if (scheduleId != null) {
        return courses.where((c) => c['scheduleId'] == scheduleId).toList();
      }
      return courses;
    } else {
      if (scheduleId != null) {
        return await _database!.query(
          'courses',
          where: 'scheduleId = ?',
          whereArgs: [scheduleId],
        );
      }
      return await _database!.query('courses');
    }
  }

  static Future<void> deleteSchedule(String scheduleId) async {
    if (kIsWeb) {
      final schedules = await getSchedules();
      schedules.removeWhere((s) => s['id'] == scheduleId);
      await _prefs!.setString('schedules', jsonEncode(schedules));

      final courses = await getCourses();
      courses.removeWhere((c) => c['scheduleId'] == scheduleId);
      await _prefs!.setString('courses', jsonEncode(courses));
    } else {
      await _database!.delete(
        'courses',
        where: 'scheduleId = ?',
        whereArgs: [scheduleId],
      );
      await _database!.delete(
        'schedules',
        where: 'id = ?',
        whereArgs: [scheduleId],
      );
    }
  }
} 