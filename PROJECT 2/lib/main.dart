// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// screens
import 'package:fixit/screens/SplashScreen.dart';
import 'package:fixit/screens/WelcomeScreen.dart';
import 'package:fixit/screens/RegisterScreen.dart';
import 'package:fixit/screens/LoginPage.dart';
import 'package:fixit/screens/DashboardPage.dart';
import 'package:fixit/screens/MapPage.dart';

// themes
import 'package:fixit/themes/theme.dart';
import 'package:fixit/themes/util.dart';

// config
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FixIt());
}

class FixIt extends StatelessWidget {
  const FixIt({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Montserrat");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixIt',
      theme: theme.light(),
      darkTheme: theme.dark(),
      highContrastTheme: theme.lightHighContrast(),
      highContrastDarkTheme: theme.darkHighContrast(),
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/map': (context) => const MapPage(),
      },
    );
  }
}