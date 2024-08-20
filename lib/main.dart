import 'package:flutter/material.dart';
import 'package:way2techv1/pages/Login_singup.dart';
import 'package:way2techv1/pages/confirm_password.dart';
import 'package:way2techv1/pages/forgot_password.dart';
import 'package:go_router/go_router.dart';

import 'pages/home.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const StartPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Loginpage(),
        ),
        GoRoute(
          path: '/forgotpassword',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/resetpassword',
          builder: (context, state) {
            final token = state.uri.queryParameters['token'] ?? '';
            return ConfirmPasswordPage(token: token);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    );

    return MaterialApp.router(
      title: 'Way2Tech',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
