// login_widgets.dart
import 'package:flutter/material.dart';
import 'package:way2techv1/pages/sign_up.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter your email',
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter your password',
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class RememberMeRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  const RememberMeRow({super.key, required this.rememberMe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          Checkbox(value: rememberMe, onChanged: onChanged),
          const Text("Remember me"),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text("Forgot password?"),
          ),
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black26)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Or"),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.black26)),
      ],
    );
  }
}

class RegisterRow extends StatelessWidget {
  const RegisterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            child: const Text("Register", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}