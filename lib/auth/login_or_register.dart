import 'package:flutter/material.dart';
import 'package:mini_ecommerce/pages/login_page.dart';
import 'package:mini_ecommerce/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool _showLoginPage = true;

  void togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    }
    return RegisterPage(
      onTap: togglePages,
    );
  }
}
