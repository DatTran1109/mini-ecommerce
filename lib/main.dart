import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mini_ecommerce/firebase_options.dart';
import 'package:mini_ecommerce/pages/cart_page.dart';
import 'package:mini_ecommerce/pages/forgot_password.dart';
import 'package:mini_ecommerce/pages/intro_page.dart';
import 'package:mini_ecommerce/pages/news_page.dart';
import 'package:mini_ecommerce/pages/product_page.dart';
import 'package:mini_ecommerce/pages/setting_page.dart';
import 'package:mini_ecommerce/pages/shop_page.dart';
import 'package:mini_ecommerce/utils/theme.dart';
import 'package:mini_ecommerce/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'data/models/shop_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox('cart');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ShopProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkTheme,
      routes: {
        '/setting_page': (context) => const SettingPage(),
        '/shop_page': (context) => const ShopPage(),
        '/cart_page': (context) => const CartPage(),
        '/product_page': (context) => const ProductPage(),
        '/news_page': (context) => const NewsPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
      home: const IntroPage(),
    );
  }
}
