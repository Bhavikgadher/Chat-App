import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        title: Text(
          'ChatApp',
          style: TextStyle(color: theme.textTheme.titleMedium?.color),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const AuthScreen()),
                );
              }
            },
            icon: Icon(Icons.exit_to_app, color: theme.primaryColor),
          ),
        ],
      ),
      body: Center(child: Text('Logged in!')),
    );
  }
}
