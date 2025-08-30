import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final int priority; // 0 = Low, 1 = Medium, 2 = High

  const PriorityChip({Key? key, required this.priority}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (priority) {
      case 0:
        text = 'Low';
        color = Colors.green;
        break;

      case 1:
        text = 'Medium';
        color = Colors.orange;
        break;

      case 2:
        text = 'High';
        color = Colors.red;
        break;

      default:
        text = 'Unknown';
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
