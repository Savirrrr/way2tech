import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:way2techv1/pages/Login_singup.dart';
import 'package:way2techv1/pages/confirm_password.dart';
import 'package:way2techv1/pages/forgot_password.dart';
import 'dart:async';

import 'pages/home.dart';
import 'pages/login_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

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
    // urlPathStrategy: UrlPathStrategy.path,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Handle the case when the app is opened from a terminated state via a deep link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        handleDeepLink(initialLink);
      }
    } on PlatformException {
      print("Exception raised");
      // Handle exception
    }

    // Handle the case when the app is already running and receives a deep link
    _sub = linkStream.listen((String? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      print("Error occurred in linkStream: $err");
      // Handle error
    });
  }

  void handleDeepLink(String link) {
    print("Received link: $link");
    final uri = Uri.parse(link);

    // Deep link handling logic
    switch (uri.path) {
      case '/resetpassword':
        final token = uri.queryParameters['token'];
        print("Token: $token");
        if (token != null) {
          _router.go('/resetpassword?token=$token');
        }
        break;
      // Add more cases here if you want to handle other paths
      default:
        print("Unhandled deep link: ${uri.path}");
        break;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Way2Tech',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
