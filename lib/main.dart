import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_auth/pages/app_pages/blocked_users.dart';

import 'package:supabase_auth/pages/app_pages/reports.dart';
import 'package:supabase_auth/pages/login_pages/lifestyle_form.dart';
import 'package:supabase_auth/pages/login_pages/login_page.dart';
import 'package:supabase_auth/pages/login_pages/preference_form.dart';
import 'package:supabase_auth/pages/login_pages/recover.dart';
import 'package:supabase_auth/pages/login_pages/signup.dart';
import 'package:supabase_auth/pages/login_pages/splash_page.dart';
import 'package:supabase_auth/pages/app_pages/structure.dart';
import 'package:supabase_auth/pages/login_pages/user_info_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  String supabaseKey = dotenv.env['SUPABASE_KEY']!;
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
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
      theme: ThemeData().copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(
        Theme.of(context).textTheme,
      )),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const MainPage(),
        '/login': (context) => const LoginPage(),
        '/recover': (context) => const RecoverAccount(),
        '/signup': (context) => const SignUp(),
        '/userform': (context) => const UserForm(),
        '/preference': (context) => const PreferenceForm(),
        '/lifestyle': (context) => const LifeStyleForm(),
        '/blocked': (context) => const BlockedUsers(),
        '/reports': (context) => const Reports(),
      },
    );
  }
}
