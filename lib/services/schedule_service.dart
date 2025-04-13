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
    try {
      // First save the course to storage
      await StorageService.saveCourse(course);
      
      // Find the schedule
      final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
      if (scheduleIndex != -1) {
        // Create a new schedule with the updated courses list
        final currentSchedule = schedules[scheduleIndex];
        final updatedCourses = List<Course>.from(currentSchedule.courses)..add(course);
        
        final updatedSchedule = Schedule(
          id: currentSchedule.id,
          name: currentSchedule.name,
          courses: updatedCourses,
        );
        
        // Update the schedules list
        schedules[scheduleIndex] = updatedSchedule;
        
        // Save the updated schedule to storage
        await StorageService.saveSchedule(updatedSchedule);
        
        // Notify listeners after all updates are complete
        notifyListeners();
      } else {
        // If schedule doesn't exist, create a new one
        final newSchedule = Schedule(
          id: scheduleId,
          name: 'New Schedule',
          courses: [course],
        );
        
        schedules.add(newSchedule);
        await StorageService.saveSchedule(newSchedule);
        notifyListeners();
      }
    } catch (e) {
      print('Error adding course to schedule: $e');
      rethrow;
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

  Future<void> deleteCourse(String scheduleId, String courseId) async {
    try {
      // Find the schedule
      final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
      if (scheduleIndex != -1) {
        // Create a new schedule with the updated courses list
        final currentSchedule = schedules[scheduleIndex];
        final updatedCourses = List<Course>.from(currentSchedule.courses)
          ..removeWhere((c) => c.id == courseId);
        
        final updatedSchedule = Schedule(
          id: currentSchedule.id,
          name: currentSchedule.name,
          courses: updatedCourses,
        );
        
        // Update the schedules list
        schedules[scheduleIndex] = updatedSchedule;
        
        // Save the updated schedule to storage
        await StorageService.saveSchedule(updatedSchedule);
        
        // Notify listeners after all updates are complete
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting course: $e');
      rethrow;
    }
  }

  Future<void> updateCourse(String scheduleId, Course updatedCourse) async {
    try {
      // First save the course to storage
      await StorageService.saveCourse(updatedCourse);
      
      // Find the schedule
      final scheduleIndex = schedules.indexWhere((s) => s.id == scheduleId);
      if (scheduleIndex != -1) {
        // Create a new schedule with the updated courses list
        final currentSchedule = schedules[scheduleIndex];
        final courseIndex = currentSchedule.courses.indexWhere((c) => c.id == updatedCourse.id);
        
        if (courseIndex != -1) {
          final updatedCourses = List<Course>.from(currentSchedule.courses)
            ..[courseIndex] = updatedCourse;
          
          final updatedSchedule = Schedule(
            id: currentSchedule.id,
            name: currentSchedule.name,
            courses: updatedCourses,
          );
          
          // Update the schedules list
          schedules[scheduleIndex] = updatedSchedule;
          
          // Save the updated schedule to storage
          await StorageService.saveSchedule(updatedSchedule);
          
          // Notify listeners after all updates are complete
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating course: $e');
      rethrow;
    }
  }

  List<String> getAllTags() {
    final Set<String> tags = {};
    for (var schedule in schedules) {
      for (var course in schedule.courses) {
        if (course.tag.isNotEmpty) {
          tags.add(course.tag);
        }
      }
    }
    return tags.toList()..sort();
  }

  List<String> getTagsForSchedule(String scheduleId) {
    final Set<String> tags = {};
    final schedule = schedules.firstWhere((s) => s.id == scheduleId, orElse: () => Schedule(id: '', name: '', courses: []));
    for (var course in schedule.courses) {
      if (course.tag.isNotEmpty) {
        tags.add(course.tag);
      }
    }
    return tags.toList()..sort();
  }
} 