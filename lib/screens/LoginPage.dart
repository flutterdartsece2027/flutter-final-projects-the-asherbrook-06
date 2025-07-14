// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// auth
import '../auth/Auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login into App"),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hint: Text("Email"),
                  prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) {
                  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                  if (value!.isEmpty) return "Email cannot be empty";
                  if (!emailRegex.hasMatch(value)) return "Enter a valid email address";
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                obscureText: _obscure,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hint: Text("Password"),
                  prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? HugeIcons.strokeRoundedView : HugeIcons.strokeRoundedViewOffSlash,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Password cannot be empty";
                  if (value.length < 6 && value.length > 16) {
                    return "Password should have 4 to 16 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an Account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Auth().login(
                        context,
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
