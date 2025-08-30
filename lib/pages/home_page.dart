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
        title: Text('TaskMaster'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarPage())),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage())),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => setState(() {
              if (v == 'All') {
                categoryFilter = null;
              } else if (v == 'SortDue') sortBy = 'due';
              else if (v == 'SortPriority') sortBy = 'priority';
              else categoryFilter = v.toLowerCase();
            }),
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'SortDue', child: Text('Sort by due date')),
              PopupMenuItem(value: 'SortPriority', child: Text('Sort by priority')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'All', child: Text('All categories')),
              PopupMenuItem(value: 'Work', child: Text('Work')),
              PopupMenuItem(value: 'Personal', child: Text('Personal')),
              PopupMenuItem(value: 'Study', child: Text('Study')),
            ],
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet — tap + to add one'))
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (ctx, i) {
                final t = tasks[i];
                return TaskCard(
                  task: t,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: t))),
                  onDelete: () async {
                    await taskModel.deleteTask(t.id);
                  },
                  onToggleComplete: () => taskModel.toggleComplete(t.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage()));
          // if added, TaskModel will have been updated inside AddTaskPage
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
