// packages
import 'package:fixit/auth/auth.dart';
import 'package:fixit/components/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// components
import '../components/CustomAppBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService Auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Login", showReturn: true),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: _email,
                validator: (value) {
                  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                  if (value!.isEmpty) return "Email should not be Empty";
                  if (!emailRegex.hasMatch(value)) return "Enter a valid email address";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                obscureText: isObscured,
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) return "Password should not be Empty";
                  if (value.length < 6 || value.length > 16) return "Password should contain 6 to 16 characters";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(isObscured ? HugeIcons.strokeRoundedView : HugeIcons.strokeRoundedViewOffSlash),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(width: 4),
                  Text("Don't have an Account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text("Register Here"),
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomElevatedButton(
                label: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Auth.login(_email.text, _password.text, context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
