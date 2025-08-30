import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';
import '../widgets/background_wrapper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          ListTile(
            title: Text('Clear all tasks'),
            subtitle: Text('Deletes all locally stored tasks'),
            trailing: ElevatedButton(
              child: Text('Clear'),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Delete all tasks permanently?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
                    ],
                  ),
                );
                if (ok == true) {
                  await StorageService().clearAll();
                  // force reload model
                  await model.loadTasksFromStorage();
                }
              },
            ),
          ),
          SizedBox(height: 12),
          ListTile(
            title: Text('About'),
            subtitle: Text('TaskMaster - minimal demo'),
          ),
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
