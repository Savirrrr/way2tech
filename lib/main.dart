import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way2techv1/pages/Login_singup.dart';
import 'package:way2techv1/pages/eventOpportunity.dart';
import 'package:way2techv1/pages/home.dart';
import 'package:way2techv1/pages/login_page.dart';
import 'package:way2techv1/pages/upload.dart';
import 'package:way2techv1/pages/account_page.dart';
import 'package:way2techv1/pages/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    String? email = prefs.getString('userEmail');

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      return '/onboarding';
    } else if (email != null && email.isNotEmpty) {
      return '/upload';
    } else {
      return '/loginsignup';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        
        
final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return FlipPageView(email: email);
      },
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return UploadPage(email: email);
      },
    ),
    GoRoute(
      path: '/tabswitch',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return Eventopprotunities(email: email);
      },
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return AccountPage(email: email);
      },
    ),
    GoRoute(
      path: '/loginsignup',
      builder: (context, state) => const StartPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Loginpage(),
    ),
  ],
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