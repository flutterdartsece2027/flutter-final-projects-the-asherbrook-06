// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null)
      Navigator.pushReplacementNamed(context, '/dashboard');
    else
      Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness == Brightness.light ? "light" : "dark";
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(child: SizedBox()),
            SvgPicture.asset("assets/$brightness/welcome.svg", width: 250),
            SizedBox(height: 16),
            Text("Welcome to FixIt", style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 4),
            Text("Where Help found Easy", style: Theme.of(context).textTheme.labelLarge),
            Expanded(child: SizedBox()),
            CupertinoActivityIndicator(color: Theme.of(context).colorScheme.primary, radius: 12),
            SizedBox(height: 36, width: MediaQuery.of(context).size.width),
          ],
        ),
      ),
    );
  }
}
