import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  final Task? existing;
  const AddTaskPage({super.key, this.existing});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  String? description;
  DateTime? dueDate;
  int priority = 1;
  String category = 'Personal';

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      title = e.title;
      description = e.description;
      dueDate = e.dueDate;
      priority = e.priority;
      category = e.category;
    } else {
      title = '';
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: dueDate != null
          ? TimeOfDay.fromDateTime(dueDate!)
          : TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final model = Provider.of<TaskModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Add Task')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/app_background.png'), // same background as HomePage
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a title' : null,
                onSaved: (v) => title = v!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (v) => description = v,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due date'),
                subtitle: Text(
                  dueDate != null
                      ? DateFormat.yMMMd().add_jm().format(dueDate!)
                      : 'No due date',
                ),
                trailing: TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick'),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: priority,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Low')),
                  DropdownMenuItem(value: 1, child: Text('Medium')),
                  DropdownMenuItem(value: 2, child: Text('High')),
                ],
                onChanged: (v) => setState(() => priority = v ?? 1),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: ['Work', 'Personal', 'Study', 'Other']
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => category = v ?? 'Personal'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  if (isEdit) {
                    final existing = widget.existing!;
                    final updated = Task(
                      id: existing.id,
                      title: title,
                      description: description,
                      dueDate: dueDate,
                      priority: priority,
                      category: category,
                      isCompleted: existing.isCompleted,
                    );
                    await model.updateTask(updated);
                  } else {
                    final newTask = Task(
                      title: title,
                      description: description,
                      dueDate: dueDate,
                      priority: priority,
                      category: category,
                    );
                    await model.addTask(newTask);
                  }
                  Navigator.pop(context, true);
                },
                child: Text(isEdit ? 'Save' : 'Add Task'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
