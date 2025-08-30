import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Clear all tasks',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Deletes all locally stored tasks',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: ElevatedButton(
                  child: const Text('Clear'),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                            'Delete all tasks permanently?'),
                        actions: [
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, false),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, true),
                              child: const Text('Delete')),
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
              const SizedBox(height: 12),
              const ListTile(
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'TaskMaster - minimal demo',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
