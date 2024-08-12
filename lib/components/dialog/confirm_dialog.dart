import 'dart:async';

import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final FutureOr<void> Function() onConfirm;
  final String title;
  final String? description;

  const ConfirmDialog({
    super.key,
    required this.onConfirm,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final ndescription = description;
    return AlertDialog(
      title: Text(title),
      content: ndescription != null ? Text(ndescription) : null,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm();
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
