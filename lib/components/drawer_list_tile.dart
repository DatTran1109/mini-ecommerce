import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? ontap;
  const DrawerListTile(
      {super.key, required this.icon, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        onTap: ontap,
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
