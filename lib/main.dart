import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:way2techv1/pages/Login_singup.dart';
import 'package:way2techv1/pages/confirm_password.dart';
import 'package:way2techv1/pages/forgot_password.dart';
import 'dart:async';

import 'pages/home.dart';
import 'pages/login_page.dart';

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
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        handleDeepLink(link);
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
    switch (uri.host) {
      case '/resetpassword':
        final token = uri.queryParameters['token'];
        print("Token: $token");
        if (token != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmPasswordPage(token: token)),
          );
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
    return MaterialApp(
      title: 'Way2Tech',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const Loginpage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
        '/resetpassword': (context) => ConfirmPasswordPage(token: ''),
      },
    );
  }
}
