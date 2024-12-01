import 'package:flutter/material.dart';

Future<String?> showLabelInputDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your label here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Dismiss without result
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text), // Return input
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
