import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import 'add_task_page.dart';
import '../widgets/background_wrapper.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage(existing: task)));
              // after editing, pop back
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await model.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(task.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Category: ${task.category}'),
          SizedBox(height: 8),
          Text('Priority: ${['Low', 'Medium', 'High'][task.priority]}'),
          SizedBox(height: 8),
          Text('Due: ${task.dueDate != null ? DateFormat.yMMMd().add_jm().format(task.dueDate!) : 'No due date'}'),
          SizedBox(height: 16),
          Text('Description:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(task.description ?? 'No description'),
        ]),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Column(
          children: const [
            Text(
              "TaskMaster",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
