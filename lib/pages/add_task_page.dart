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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: dueDate != null
          ? TimeOfDay.fromDateTime(dueDate!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.black,
              hourMinuteTextColor: Colors.white,
              dialTextColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
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
            image: AssetImage('lib/assets/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: title,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter a title' : null,
                  onSaved: (v) => title = v!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: description,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  maxLines: 3,
                  onSaved: (v) => description = v,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Due date', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    dueDate != null
                        ? DateFormat.yMMMd().add_jm().format(dueDate!)
                        : 'No due date',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: TextButton(
                    onPressed: _pickDateTime,
                    child: const Text('Pick', style: TextStyle(color: Colors.purple)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  dropdownColor: Colors.black,
                  value: priority,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Low', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 1, child: Text('Medium', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 2, child: Text('High', style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (v) => setState(() => priority = v ?? 1),
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  value: category,
                  items: ['Work', 'Personal', 'Study', 'Other']
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => category = v ?? 'Personal'),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
