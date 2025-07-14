// packages
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

// auth
import '../auth/Auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        Auth().checkLoggedIn(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = View.of(context).platformDispatcher.platformBrightness == Brightness.light
        ? 'light'
        : 'dark';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              SvgPicture.asset('assets/$theme/welcome.svg', width: 250),
              SizedBox(height: 24),
              Text("Welcome to Linker", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 4),
              Text("Where people connect...", style: Theme.of(context).textTheme.labelMedium),
              Expanded(child: SizedBox()),
              CircularProgressIndicator(year2023: true),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
