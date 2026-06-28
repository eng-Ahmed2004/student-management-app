import 'package:flutter/material.dart';

// Shows a confirmation dialog before deleting a student.
// Returns true if the user confirms, false/null otherwise.
Future<bool?> showConfirmDeleteDialog(
  BuildContext context, {
  required String studentName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Student'),
        content: Text(
          'Are you sure you want to delete "$studentName"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}