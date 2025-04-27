import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.none) {
            _showConnectionErrorDialog(ctx);
            return const Scaffold(
              body: Center(
                child: Text(
                  'Connection Error!',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return _buildSplashScreenWithDelay(const ChatScreen());
          }
          return _buildSplashScreenWithDelay(const AuthScreen());
        },
      ),
    );
  }

  Widget _buildSplashScreenWithDelay(Widget destination) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        return destination;
      },
    );
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF5865F2),
    // Discord blue
    scaffoldBackgroundColor: Color(0xFFF2F3F5),
    // Very light gray
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF5865F2),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF5865F2),
      secondary: Color(0xFF99AAB5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5865F2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Color(0xFF5865F2)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5865F2)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5865F2)),
      ),
      labelStyle: TextStyle(color: Color(0xFF5865F2)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C2F33), // Very dark text
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF23272A),
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF2C2F33)),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Color(0xFF99AAB5), // Subtle text
      ),
    ),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF5865F2),
    // Same discord blue
    scaffoldBackgroundColor: Color(0xFF36393F),
    // Discord dark background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2F3136),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardColor: Color(0xFF40444B),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF5865F2),
      secondary: Color(0xFF99AAB5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5865F2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Color(0xFF5865F2)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5865F2)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5865F2)),
      ),
      labelStyle: TextStyle(color: Color(0xFF5865F2)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Bright for dark background
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFDCDDDE), // Soft white
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFC0C0C0)),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Color(0xFF99AAB5), // Faded text
      ),
    ),
  );

  void _showConnectionErrorDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCupertinoDialog(
        context: context,
        builder:
            (ctx2) => CupertinoAlertDialog(
              title: const Text('Check your Internet Connection'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx2).pop();
                  },
                ),
              ],
            ),
      );
    });
  }
}
