import 'package:flutter/material.dart';
import 'package:way2techv1/pages/Login_singup.dart';
import 'package:way2techv1/pages/confirm_password.dart';
import 'package:way2techv1/pages/forgot_password.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/onboarding_screen.dart';
import 'pages/home.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      return '/onboarding';
    } else {
      return '/loginsignup'; // Redirect to home if it's not the first run
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while checking initial route
        }

        final GoRouter router = GoRouter(
          initialLocation: snapshot.data ?? '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const Scaffold(), // Placeholder widget, actual routing logic below
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
              path: '/loginsignup',
              builder: (context, state) => const StartPage(),
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
            GoRoute(
              path: '/onboarding',
              builder: (context, state) => const OnboardingScreen(),
            ),
          ],
          errorBuilder: (context, state) => Scaffold(
            body: Center(child: Text(state.error.toString())),
          ),
        );

        return MaterialApp.router(
          title: 'Way2Tech',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
