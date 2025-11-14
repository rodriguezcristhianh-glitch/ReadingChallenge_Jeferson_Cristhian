import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_final/src/views/login_page.dart';
import 'package:proyecto_final/src/views/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async 
{
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  runApp(const MainApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp.router(
      routerConfig: GoRouter(
        
        initialLocation: '/home',
        routes: [
          GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginPage()),
          GoRoute(path: '/home', name: 'home', builder: (context, state) => HomePage())
        ]
      ),
      showSemanticsDebugger: false,
    );
  }
}
