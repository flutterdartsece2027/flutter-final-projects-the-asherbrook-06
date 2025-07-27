// packages
import 'package:fixit/auth/auth.dart';
import 'package:fixit/components/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// components
import '../components/CustomAppBar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthService Auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repeatPassword = TextEditingController();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Register", showReturn: true),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: _name,
                validator: (value) {
                  if (value!.isEmpty) return "Name should not be Empty";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(HugeIcons.strokeRoundedUser02),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
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
                controller: _phone,
                validator: (value) {
                  final emailRegex = RegExp(r"^\d{10}$");
                  if (value!.isEmpty) return "Phone Number should not be Empty";
                  if (value.length > 10) return "Phone Number's length should be less than 10";
                  if (!emailRegex.hasMatch(value)) return "Enter a valid Phone Number";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Phone",
                  prefixIcon: Icon(HugeIcons.strokeRoundedCall02),
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
              SizedBox(height: 16),
              TextFormField(
                obscureText: isObscured,
                controller: _repeatPassword,
                validator: (value) {
                  if (value!.isEmpty) return "Password should not be Empty";
                  if (value.length < 6 || value.length > 16) return "Password should contain 6 to 16 characters";
                  if (_password.text != _repeatPassword.text) return "Passwords should match";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Repeat Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(isObscured ? HugeIcons.strokeRoundedView : HugeIcons.strokeRoundedViewOffSlash),
                  ),
                  prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(width: 4),
                  Text("Already have an Account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Login Here"),
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomElevatedButton(
                label: "Register",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Auth.register(_email.text, _password.text, _name.text, _phone.text, context);
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
