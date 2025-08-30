import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _tasksKey = 'taskmaster_tasks';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveTasks(String json) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_tasksKey, json);
  }

  String? loadTasks() {
    return _prefs?.getString(_tasksKey);
  }

  Future<void> clearAll() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_tasksKey);
  }
}
