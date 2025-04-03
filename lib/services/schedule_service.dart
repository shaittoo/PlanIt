import 'package:flutter/foundation.dart';
import '../models/schedule.dart';
import '../models/course.dart';

class ScheduleService extends ChangeNotifier {
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;

  Future<void> init() async {
    print('Initializing ScheduleService (memory version)...');
    await createTestSchedule();
    print('Initialization complete!');
  }

  Future<void> createTestSchedule() async {
    print('Creating test schedule...');
    final types = ['2nd Semester', 'Work Schedule', '2nd Semester'];
    final randomIndex = _schedules.length % 3;
    
    final schedule = Schedule(
      name: types[randomIndex],
    );
    
    _schedules.add(schedule);
    notifyListeners();
    print('Test schedule created successfully');
  }

  Future<void> addSchedule(Schedule schedule) async {
    _schedules.add(schedule);
    notifyListeners();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index >= 0) {
      _schedules[index] = schedule;
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  Future<void> addCourseToSchedule(String scheduleId, Course course) async {
    final scheduleIndex = _schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex >= 0) {
      _schedules[scheduleIndex].courses.add(course);
      notifyListeners();
    }
  }

  Future<void> updateCourse(Course course) async {
    final scheduleIndex = _schedules.indexWhere((s) => s.id == course.scheduleId);
    if (scheduleIndex >= 0) {
      final courseIndex = _schedules[scheduleIndex].courses.indexWhere((c) => c.id == course.id);
      if (courseIndex >= 0) {
        _schedules[scheduleIndex].courses[courseIndex] = course;
        notifyListeners();
      }
    }
  }

  Future<void> deleteCourse(String scheduleId, String courseId) async {
    final scheduleIndex = _schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex >= 0) {
      _schedules[scheduleIndex].courses.removeWhere((c) => c.id == courseId);
      notifyListeners();
    }
  }
} 