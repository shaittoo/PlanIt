import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../models/course.dart';
import 'storage_service.dart';

class ScheduleService extends ChangeNotifier {
  List<Schedule> schedules = [];

  Future<void> initDatabase() async {
    await StorageService.init();
    await loadSchedules();
  }

  Future<void> loadSchedules() async {
    schedules = StorageService.getAllSchedules();
    for (var schedule in schedules) {
      schedule.courses = StorageService.getCoursesForSchedule(schedule.id);
    }
    notifyListeners();
  }

  Future<void> saveSchedule(Schedule schedule) async {
    await StorageService.saveSchedule(schedule);
    await loadSchedules();
  }

  Future<void> addCourseToSchedule(String scheduleId, Course course) async {
    await StorageService.saveCourse(course);
    final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex != -1) {
      schedules[scheduleIndex].courses.add(course);
      await StorageService.saveSchedule(schedules[scheduleIndex]);
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await StorageService.deleteSchedule(scheduleId);
    await loadSchedules();
  }

  void addSchedule(Schedule schedule) {
    print('Adding schedule: ${schedule.id}');
    schedules.add(schedule);
    notifyListeners();
  }

  Future<Schedule> createSchedule(String name) async {
    final schedule = Schedule(name: name);
    schedules.add(schedule);
    notifyListeners();
    return schedule;
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final index = schedules.indexWhere((s) => s.id == schedule.id);
    if (index >= 0) {
      schedules[index] = schedule;
      notifyListeners();
    }
  }

  void deleteCourse(String scheduleId, String courseId) {
    final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex != -1) {
      schedules[scheduleIndex].courses.removeWhere((c) => c.id == courseId);
      notifyListeners();
    }
  }

  void updateCourse(String scheduleId, Course updatedCourse) {
    final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex != -1) {
      final courseIndex = schedules[scheduleIndex].courses
          .indexWhere((c) => c.id == updatedCourse.id);
      if (courseIndex != -1) {
        schedules[scheduleIndex].courses[courseIndex] = updatedCourse;
        notifyListeners();
      }
    }
  }


} 