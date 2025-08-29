import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'priority_chip.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const TaskCard({super.key, required this.task, required this.onTap, this.onDelete, this.onToggleComplete});

  @override
  Widget build(BuildContext context) {
    final dueText = task.dueDate != null ? DateFormat.yMMMd().add_jm().format(task.dueDate!) : 'No due date';
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggleComplete?.call(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('$dueText • ${task.category}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          PriorityChip(priority: task.priority),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: onDelete,
          )
        ]),
      ),
    );
  }
}
