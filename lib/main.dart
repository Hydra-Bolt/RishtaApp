import 'package:flutter/material.dart';
import 'package:supabase_auth/pages/account_page.dart';
import 'package:supabase_auth/pages/home.dart';
import 'package:supabase_auth/pages/login_page.dart';
import 'package:supabase_auth/pages/signup.dart';
import 'package:supabase_auth/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://hoogaibcqnhvxbqmkpvo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhvb2dhaWJjcW5odnhicW1rcHZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY3MTM4NTgsImV4cCI6MjAzMjI4OTg1OH0.q8RL7Sprp1U1ah6UGRPgOJ_H0x-avfh6U-5CEtGdJv8',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUp(),
        '/account': (context) => const AccountPage(),
      },
    );
  }
}
