// login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:way2techv1/pages/forgot_password.dart';
import 'package:way2techv1/service/auth_service.dart';
import 'package:way2techv1/widget/login_widgets.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _rememberMe = false;s
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    bool isSuccess = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      // Navigate to home page and pass email
      context.go('/home', extra: email);
    } else {
      // Login failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Email"),
              ),
              const SizedBox(height: 5),
              EmailField(emailController: _emailController),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Password"),
              ),
              const SizedBox(height: 5),
              PasswordField(passwordController: _passwordController),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Log In", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),
              const RegisterRow(),
            ],
          ),
        ),
      ),
    );
  }
}