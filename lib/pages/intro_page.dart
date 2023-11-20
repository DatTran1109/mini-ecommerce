import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/auth/auth.dart';
import 'package:mini_ecommerce/components/my_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/intro_page.json'),
            const SizedBox(height: 25),
            const Text(
              'Mini Ecommerce',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Premium quality products',
            ),
            const SizedBox(height: 50),
            MyButton(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Auth(),
                ),
              ),
              child: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
