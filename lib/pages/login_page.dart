import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/my_button.dart';
import 'package:mini_ecommerce/components/square_tile.dart';
import 'package:mini_ecommerce/components/text_field.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

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

  void signIn(BuildContext context, TextEditingController emailTextController,
      TextEditingController passwordTextController) async {
    if (emailTextController.text == '' || passwordTextController.text == '') {
      showMessage(context, 'Email and password required');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Center(
        child: Lottie.asset('assets/animations/loading.json'),
      ),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text)
          .whenComplete(() => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      showMessage(context, e.code);
    }
  }

  Future googleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      showDialog(
        context: context,
        builder: (context) => Center(
          child: Lottie.asset('assets/animations/loading.json'),
        ),
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showMessage(context, e.code);
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Column(
            children: [
              Lottie.asset('assets/animations/login.json'),
              const Text(
                "Welcome to mini ecommerce",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const SizedBox(height: 40),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => signIn(
                  context,
                  emailTextController,
                  passwordTextController,
                ),
                child: const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/forgot_password'),
                        child: const Text('Forgot password')),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(thickness: 0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(thickness: 0.5),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                    onTap: () => googleSignIn(context),
                    child: const SquareTile(
                        imagePath: "assets/images/google.png")),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Register now',
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
