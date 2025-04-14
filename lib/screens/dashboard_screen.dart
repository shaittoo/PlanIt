import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/schedule_service.dart';
import '../../services/storage_service.dart';
import '../../models/schedule.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'User';
  String selectedFilter = 'All';
  String sortBy = 'Newest';
  final List<String> filterOptions = ['All', 'School', 'Work', 'Personal'];
  final List<String> sortOptions = ['Newest', 'Oldest', 'A-Z', 'Z-A'];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await StorageService.getUserName();
    setState(() {
      userName = name;
    });
  }

  Future<void> _editUserName() async {
    String? result;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final TextEditingController controller = TextEditingController(
          text: userName,
        );
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                result = controller.text.trim();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result!.isNotEmpty) {
      await StorageService.saveUserName(result!);
      if (mounted) {
        setState(() {
          userName = result!;
        });
      }
    }
  }

  Future<void> _editScheduleTitle(
    BuildContext context,
    ScheduleService scheduleService,
    Schedule schedule,
  ) async {
    String? result;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final TextEditingController controller = TextEditingController(
          text: schedule.name,
        );
        return AlertDialog(
          title: const Text('Edit Schedule Title'),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter schedule title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                result = controller.text.trim();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result!.isNotEmpty) {
      schedule.name = result!;
      await scheduleService.updateSchedule(schedule);
      if (mounted) {
        setState(() {});
      }
    } else if (result != null && result!.isEmpty) {
      // Prompt the user if the title is empty
      await Future.delayed(Duration.zero); // Ensure dialog runs after UI update
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Invalid Title'),
              content: const Text(
                'The schedule title cannot be empty. Please enter a valid title.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _showFilterDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter & Sort'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Tag',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: filterOptions.map((filter) {
                      return ChoiceChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sort by',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: sortOptions.map((sort) {
                      return ChoiceChip(
                        label: Text(sort),
                        selected: sortBy == sort,
                        onSelected: (selected) {
                          setState(() {
                            sortBy = sort;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  List<Schedule> _getFilteredSchedules(List<Schedule> schedules) {
    List<Schedule> filtered = schedules;

    // Apply tag filter
    if (selectedFilter != 'All') {
      filtered = filtered.where((schedule) {
        return schedule.courses.any((course) => course.tag == selectedFilter);
      }).toList();
    }

    // Apply sorting
    switch (sortBy) {
      case 'Newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'A-Z':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return filtered;
  }

  String _formatDate(DateTime date) {
    final day = date.day;
    final month = _getMonthName(date.month);
    final year = date.year;
    return '$month $day, $year';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hello,',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: _editUserName,
                    child: Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF00B4FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Schedules',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: _showFilterDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Filters',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: selectedFilter != 'All' || sortBy != 'Newest'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Consumer<ScheduleService>(
                        builder: (context, scheduleService, child) {
                          final filteredSchedules = _getFilteredSchedules(scheduleService.schedules);
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                            itemCount: filteredSchedules.length,
                            itemBuilder: (context, index) {
                              final schedule = filteredSchedules[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/schedule-detail',
                                    arguments: schedule.id,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  schedule.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () async {
                                                    await _editScheduleTitle(
                                                      context,
                                                      scheduleService,
                                                      schedule,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Created on ${_formatDate(schedule.createdAt)}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: schedule.courses
                                                    .where((course) => course.tag.isNotEmpty)
                                                    .map((course) => course.tag)
                                                    .toSet()
                                                    .map((tag) {
                                                  Color tagColor;
                                                  switch (tag) {
                                                    case 'School':
                                                      tagColor = Colors.green;
                                                      break;
                                                    case 'Work':
                                                      tagColor = Colors.red;
                                                      break;
                                                    default:
                                                      tagColor = Colors.blue;
                                                  }
                                                  return Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 8,
                                                      right: 8,
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: tagColor,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      tag,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    'Delete Schedule',
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete "${schedule.name}"? This action cannot be undone.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await scheduleService
                                                            .deleteSchedule(
                                                              schedule.id,
                                                            );
                                                        Navigator.pop(context);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                Colors.red,
                                                          ),
                                                      child: const Text(
                                                        'Delete',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 24),
        width: 150,
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/create-schedule');
          },
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Create New',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
