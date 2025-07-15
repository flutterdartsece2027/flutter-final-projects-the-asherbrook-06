// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// screens
import 'package:buzz/screens/NewBroadcastPage.dart';
import 'package:buzz/screens/EditProfilePage.dart';
import 'package:buzz/screens/AddContactPage.dart';
import 'package:buzz/screens/DashboardPage.dart';
import 'package:buzz/screens/GroupInfoPage.dart';
import 'package:buzz/screens/SplashScreen.dart';
import 'package:buzz/screens/ChatInfoPage.dart';
import 'package:buzz/screens/RegisterPage.dart';
import 'package:buzz/screens/NewGroupPage.dart';
import 'package:buzz/screens/WelcomePage.dart';
import 'package:buzz/screens/PreviewPage.dart';
import 'package:buzz/screens/NewChatPage.dart';
import 'package:buzz/screens/ProfilePage.dart';
import 'package:buzz/screens/LoginPage.dart';
import 'package:buzz/screens/ChatPage.dart';

// components
import 'package:buzz/components/CameraScreen.dart';

// themes
import 'package:buzz/themes/theme.dart';
import 'package:buzz/themes/util.dart';

// model
import 'package:buzz/models/User.dart';
import 'package:buzz/models/Chat.dart';

// config
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  cameras = await availableCameras();

  runApp(const Buzz());
}

class Buzz extends StatelessWidget {
  const Buzz({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Nunito");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linker',
      theme: theme.light(),
      darkTheme: theme.dark(),
      highContrastTheme: theme.lightHighContrast(),
      highContrastDarkTheme: theme.darkHighContrast(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(),
        '/profile': (context) => const ProfilePage(),
        '/newChat': (context) => const NewChatPage(),
        '/register': (context) => const RegisterPage(),
        '/newGroup': (context) => const NewGroupPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/addContact': (context) => const AddContactPage(),
        '/newBroadcast': (context) => const NewBroadcastPage(),
        '/editProfile': (context) {
          final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
          return EditProfilePage(user: user);
        },
        '/chat': (context) {
          final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;
          return ChatPage(chat: chat);
        },
        '/chatInfo': (context) {
          final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;
          return ChatInfoPage(chat: chat);
        },
        '/groupInfo': (context) {
          final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;
          return GroupInfoPage(chat: chat);
        },
        '/preview': (context) {
          final String path = ModalRoute.of(context)!.settings.arguments?['path'] as String;
          final Chat chat = ModalRoute.of(context)!.settings.arguments?['chat'] as Chat;
          return CameraPreviewPage(path: path, chat: chat);
        },
      },
    );
  }
}

extension on Object? {
  void operator [](String other) {}
}
