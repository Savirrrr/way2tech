import 'package:flutter/material.dart';
import 'package:way2techv1/pages/login_page.dart';
import 'package:way2techv1/pages/sign_up.dart';
import 'package:way2techv1/widget/custom_buttons_signup.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Log In",
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginpage()),
                );
              },
              verticalPadding: 15,
              horizontalPadding: 103,
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Sign Up",
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              verticalPadding: 15,
              horizontalPadding: 100,
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Or"),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SocialLoginButton(
              imagePath: 'assets/images/google.png',
              text: "Continue with Google",
              onPressed: () {
                // Google login logic
              },
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              imagePath: 'assets/images/linkedin.png',
              text: "Continue with LinkedIn",
              onPressed: () {
                // LinkedIn login logic
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}