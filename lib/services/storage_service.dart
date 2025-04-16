
import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule.dart';
import '../models/course.dart';
import 'hive_adapters.dart';

class StorageService {
  static late Box<Schedule> _scheduleBox;
  static late Box<Course> _courseBox;
  static late Box<String> _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(CourseAdapter());
    
    _scheduleBox = await Hive.openBox<Schedule>('schedules');
    _courseBox = await Hive.openBox<Course>('courses');
    _settingsBox = await Hive.openBox<String>('settings');
  }

  static Future<void> saveSchedule(Schedule schedule) async {
    await _scheduleBox.put(schedule.id, schedule);
  }

  static List<Schedule> getAllSchedules() {
    return _scheduleBox.values.toList();
  }

  static Future<void> deleteSchedule(String scheduleId) async {
    await _scheduleBox.delete(scheduleId);
    
    final coursesToDelete = _courseBox.values
        .where((course) => course.scheduleId == scheduleId)
        .toList();
    
    await Future.wait(
      coursesToDelete.map((course) => _courseBox.delete(course.id))
    );
  }

  static Future<void> saveCourse(Course course) async {
    await _courseBox.put(course.id, course);
  }

  static List<Course> getCoursesForSchedule(String scheduleId) {
    return _courseBox.values
        .where((course) => course.scheduleId == scheduleId)
        .toList();
  }

  static Future<void> clear() async {
    await Future.wait([
      _scheduleBox.clear(),
      _courseBox.clear(),
    ]);
  }

  static bool isInitialized() {
    return Hive.isBoxOpen('schedules') && Hive.isBoxOpen('courses');
  }

  static Future<void> saveData(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static dynamic getData(String key) {
    return _settingsBox.get(key);
  }

  static const String _userNameKey = 'userName';
  
  static Future<void> saveUserName(String name) async {
    await _settingsBox.put(_userNameKey, name);
  }

  static Future<String> getUserName() async {
    return _settingsBox.get(_userNameKey) ?? 'User';
  }
} 