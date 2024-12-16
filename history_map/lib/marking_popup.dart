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
Future<Map<String, dynamic>?> showLabelInputAndAngleDialog(BuildContext context) async {
  final TextEditingController labelController = TextEditingController();
  final TextEditingController angleController = TextEditingController();
  bool isRiver = false;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Enter Label, Angle, and Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    hintText: 'Enter your label here',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: angleController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter the angle',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isRiver,
                      onChanged: (bool? value) {
                        setState(() {
                          isRiver = value ?? false;
                        });
                      },
                    ),
                    Text('Is River'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Dismiss without result
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final label = labelController.text;
                  final angle = angleController.text;
                  Navigator.pop(context, {
                    'label': label,
                    'angle': angle,
                    'isRiver': isRiver,
                  }); // Return input
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}
