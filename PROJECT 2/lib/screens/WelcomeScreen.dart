// packages
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

// components
import 'package:fixit/components/CustomElevatedButton.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            CustomElevatedButton(
              label: "Register",
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            SizedBox(height: 4),
            CustomElevatedButton(
              label: "Login",
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
