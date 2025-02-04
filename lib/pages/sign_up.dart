import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'package:way2techv1/pages/login_page.dart';
import 'package:way2techv1/service/auth_service.dart';
import 'package:way2techv1/pages/otp.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _passwordStrengthMessage = "";
  Color _passwordStrengthColor = Colors.red;
  String _usernameError = "";

  final AuthService _authService = AuthService(); // Instantiate the service

  void _checkPasswordStrength(String password) {
    double strength = estimatePasswordStrength(password);

    if (strength < 0.3) {
      _passwordStrengthMessage = "Weak Password";
      _passwordStrengthColor = Colors.red;
    } else if (strength < 0.7) {
      _passwordStrengthMessage = "Medium Password";
      _passwordStrengthColor = Colors.yellow;
    } else {
      _passwordStrengthMessage = "Strong Password";
      _passwordStrengthColor = Colors.green;
    }

    setState(() {});
  }

  Future<void> _handleSignUp() async {
    String username = _usernameController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      bool usernameTaken = await _authService.checkIfUsernameExists(username);
      if (usernameTaken) {
        setState(() {
          _usernameError = 'Username is already taken';
        });
        return;
      } else {
        setState(() {
          _usernameError = '';
        });
      }

      bool success = await _authService.signUpUser(username, firstName, lastName, email, password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Sign-Up Successful. Please verify your email.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                    email: email,
                    username: username,
                    isRegistration: true,
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-Up Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Username"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your username',
                    errorText: _usernameError.isNotEmpty ? _usernameError : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("First Name"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your first name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Last Name"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your last name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Email"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Password"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: _checkPasswordStrength,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      _passwordStrengthMessage,
                      style: TextStyle(color: _passwordStrengthColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: Text("Confirm Password"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 120,
                    ),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginpage(),
                        ),
                      );
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}