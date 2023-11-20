import 'package:flutter/material.dart';
import 'package:mini_ecommerce/components/drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onSettingTap;
  final Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onSignOut,
    required this.onSettingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        const DrawerHeader(
            child: Icon(
          Icons.shopping_bag,
          size: 72,
        )),
        const SizedBox(height: 25),
        DrawerListTile(
          icon: Icons.home,
          text: 'H O M E',
          ontap: () => Navigator.pop(context),
        ),
        DrawerListTile(
          icon: Icons.settings,
          text: 'S E T T I N G',
          ontap: onSettingTap,
        ),
        DrawerListTile(
          icon: Icons.logout,
          text: 'L O G O U T',
          ontap: onSignOut,
        ),
      ]),
    );
  }
}
