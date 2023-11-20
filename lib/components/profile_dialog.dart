import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final String field;
  final Function()? onSave;
  final Function()? onCancel;
  final TextEditingController controller;
  const ProfileDialog(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.controller,
      required this.field});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit $field'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter new $field',
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(12)),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
        ),
      ),
      actions: [
        MaterialButton(onPressed: onSave, child: const Text('Save')),
        MaterialButton(onPressed: onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
