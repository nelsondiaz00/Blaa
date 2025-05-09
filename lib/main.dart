import 'package:blaa/entity/user.dart';
import 'package:blaa/firebase_options.dart';
import 'package:blaa/screens/chat_screen.dart';
import 'package:blaa/screens/home_screen.dart';
import 'package:blaa/screens/login_screen.dart';
import 'package:blaa/screens/profile_screen.dart';
import 'package:blaa/screens/sign_up_screen.dart';
import 'package:blaa/screens/users_screen.dart';
import 'package:blaa/services/firebase_service.dart';
import 'package:blaa/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseService().initializeNotifications();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '${record.level.name}: ${record.time}: [${record.loggerName}] ${record.message}',
      );
    }
  });
  String? token = await AuthService().getStoredToken();

  runApp(MyApp(initialRoute: token != null ? '/messaging' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/sign-up':
            return MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            );
          case '/messaging':
            return MaterialPageRoute(builder: (context) => const UserScreen());
          case '/profile':
            final User? user = settings.arguments as User?;
            if (user == null) {
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );
            }
            return MaterialPageRoute(
              builder: (context) => ProfileScreen(user: user),
            );
          case '/chat':
            final User? user = settings.arguments as User?;
            if (user == null) {
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );
            }
            return MaterialPageRoute(
              builder: (context) => ChatScreen(userRecipient: user),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
