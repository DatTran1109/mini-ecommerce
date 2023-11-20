import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_ecommerce/components/my_drawer.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      drawer: MyDrawer(
        onSignOut: signOut,
        onSettingTap: () => Navigator.pushNamed(context, '/setting_page'),
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Center(
            child: Text('Coming soon!'),
          ),
        ],
      ),
    );
  }
}
