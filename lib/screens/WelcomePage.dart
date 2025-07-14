// packages
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = View.of(context).platformDispatcher.platformBrightness == Brightness.light
        ? 'light'
        : 'dark';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: SizedBox()),
            SvgPicture.asset('assets/$theme/welcome.svg', width: 250),
            SizedBox(height: 24),
            Text("Welcome to Linker", style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 4),
            Text("Where people connect...", style: Theme.of(context).textTheme.labelMedium),
            Expanded(child: SizedBox()),
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
