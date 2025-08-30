import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import 'task_detail_page.dart';
import '../widgets/task_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  List<Task> _tasksForDay(List<Task> tasks, DateTime day) {
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == day.year &&
          t.dueDate!.month == day.month &&
          t.dueDate!.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskModel>(context);
    final allTasks = model.tasks;
    final tasksToday =
        _selected != null ? _tasksForDay(allTasks, _selected!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2100),
              focusedDay: _focused,
              selectedDayPredicate: (d) => isSameDay(d, _selected),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selected = selectedDay;
                  _focused = focusedDay;
                });
              },
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.purple, width: 2),
                  ),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final tasks = _tasksForDay(allTasks, day);
                  if (tasks.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Text(
                          '${tasks.length}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: _selected == null
                  ? const Center(
                      child: Text(
                        'Select a day to view tasks',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : tasksToday.isEmpty
                      ? const Center(
                          child: Text(
                            'No tasks on selected day',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasksToday.length,
                          itemBuilder: (ctx, i) {
                            final t = tasksToday[i];
                            return TaskCard(
                              task: t,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailPage(task: t),
                                ),
                              ),
                              onDelete: () => model.deleteTask(t.id),
                              onToggleComplete: () =>
                                  model.toggleComplete(t.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
