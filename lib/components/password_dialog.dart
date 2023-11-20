import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  final String field;
  final Function()? onSave;
  final Function()? onCancel;
  final TextEditingController oldPasswordcontroller;
  final TextEditingController newPasswordcontroller;
  final TextEditingController confirmPasswordcontroller;
  const PasswordDialog(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.newPasswordcontroller,
      required this.confirmPasswordcontroller,
      required this.field,
      required this.oldPasswordcontroller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset $field'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: oldPasswordcontroller,
            autofocus: true,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter old $field',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: newPasswordcontroller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: confirmPasswordcontroller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm $field',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(onPressed: onSave, child: const Text('Save')),
        MaterialButton(onPressed: onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
