import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/my_button.dart';
import 'package:mini_ecommerce/components/text_field.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void signUp(
      BuildContext context,
      TextEditingController emailTextController,
      TextEditingController passwordTextController,
      TextEditingController passwordConfirmTextController) async {
    if (emailTextController.text.trim() == '' ||
        passwordTextController.text.trim() == '' ||
        passwordConfirmTextController.text.trim() == '') {
      showMessage(context, 'All fields are required');
      return;
    }

    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(emailTextController.text.trim()) ==
        false) {
      showMessage(context, 'Email is not valid');
      return;
    }

    if (passwordTextController.text.trim() !=
        passwordConfirmTextController.text.trim()) {
      showMessage(context, 'Password confirmation does not match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text.trim(),
              password: passwordTextController.text.trim());

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextController.text.trim().split('@')[0],
        'address': 'Empty address..',
        'role': 'user'
      });
    } on FirebaseAuthException catch (e) {
      showMessage(context, e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    final passwordConfirmTextController = TextEditingController();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(children: [
          Column(
            children: [
              Lottie.asset('assets/animations/register.json'),
              const Text(
                "Lets create an account",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 30),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordConfirmTextController,
                  hintText: 'Password Confirm',
                  obscureText: true),
              const SizedBox(height: 20),
              MyButton(
                onTap: () => signUp(
                  context,
                  emailTextController,
                  passwordTextController,
                  passwordConfirmTextController,
                ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700),
                      ))
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ]),
      ),
    ));
  }
}
