import 'package:flutter/material.dart';

Future<bool> confirmDelete(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text("Delete Book"),
          content: Text("Are you sure you want to delete this book?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ) ??
      false;
}