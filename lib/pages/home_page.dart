import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sortBy = 'due';
  String? categoryFilter;

  @override
  Widget build(BuildContext context) {
    final taskModel = Provider.of<TaskModel>(context);
    final tasks = taskModel.tasksSorted(sortBy: sortBy, category: categoryFilter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => setState(() {
              if (v == 'All') {
                categoryFilter = null;
              } else if (v == 'SortDue') {
                sortBy = 'due';
              } else if (v == 'SortPriority') {
                sortBy = 'priority';
              } else {
                categoryFilter = v.toLowerCase();
              }
            }),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'SortDue', child: Text('Sort by due date')),
              const PopupMenuItem(value: 'SortPriority', child: Text('Sort by priority')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'All', child: Text('All categories')),
              const PopupMenuItem(value: 'Work', child: Text('Work')),
              const PopupMenuItem(value: 'Personal', child: Text('Personal')),
              const PopupMenuItem(value: 'Study', child: Text('Study')),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/app_background.png'), // change to your image name
            fit: BoxFit.cover,
          ),
        ),
        child: tasks.isEmpty
            ? const Center(
                child: Text(
                  'No tasks yet — tap + to add one',
                  style: TextStyle(color: Colors.white), // so text is visible
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: tasks.length,
                itemBuilder: (ctx, i) {
                  final t = tasks[i];
                  return TaskCard(
                    task: t,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailPage(task: t)),
                    ),
                    onDelete: () async {
                      await taskModel.deleteTask(t.id);
                    },
                    onToggleComplete: () => taskModel.toggleComplete(t.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
