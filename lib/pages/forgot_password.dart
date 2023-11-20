import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  Future passwordReset(BuildContext context, String email) async {
    if (email == '') {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Please fill in your email address!'),
              ));
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text('Password reset link sent!'),
                ));
      } on FirebaseAuthException catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(e.message.toString()),
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Enter your email to receive password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12)),
                fillColor: Theme.of(context).colorScheme.primary,
                filled: true,
                hintText: 'Email',
              ),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            onPressed: () => passwordReset(context, emailController.text),
            padding: const EdgeInsets.all(12),
            color: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Reset Password',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
