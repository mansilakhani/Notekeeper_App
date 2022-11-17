import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fm_notes_app/screens/homepage.dart';
import 'package:fm_notes_app/screens/notes_editor.dart';
import 'package:fm_notes_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      routes: {
        '/': (context) => HomePage(),
        'splash_screen': (context) => SplashScreen(),
        'notes_editor': (context) => NoteEditor_Page(),
      },
    ),
  );
}
