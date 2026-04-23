import 'package:flutter/material.dart';

Future<bool> confirmSaveChanges(
  BuildContext context,
  String title,
  String author,
  bool? isRead,
) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ ICON
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(83, 76, 175, 79),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.save, color: Colors.green, size: 28),
                  ),

                  const SizedBox(height: 16),

                  // 🧾 TITLE
                  Text(
                    "Save Changes?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Do you want to save these changes?",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 16),

                  // 📚 BOOK INFO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          author,
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (isRead != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                isRead
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 16,
                                color:
                                    isRead ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isRead ? "Read" : "Not Read",
                                style: TextStyle(
                                  color: isRead
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔘 ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, false),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () =>
                              Navigator.pop(dialogContext, true),
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}