import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_final/src/views/login_page.dart';
import 'package:proyecto_final/src/views/home_page.dart';
import 'package:proyecto_final/src/views/stadistics.dart';
import 'firebase_options.dart';
import 'package:proyecto_final/src/views/admin_book_page.dart';

void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    print('Current user: ${FirebaseAuth.instance.currentUser}');

    return MaterialApp.router(
      routerConfig: GoRouter(
        
        redirect: (context, state) 
        {
          final user = FirebaseAuth.instance.currentUser;

          final freeRoutes = ['/register'];

          if (user == null && !freeRoutes.contains(state.fullPath)) 
          {
            return '/login';
          }

          return null;
        },
        initialLocation: '/stadistics',
        routes: [
          GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginPage()),
          GoRoute(path: '/register', name: 'register', builder: (context, state) => 
          Scaffold(
            appBar: AppBar(title: const Text('Registrarse')),
            body: const Center(child: Text('Registro de usuario')),
          )),
          GoRoute(path: '/home', name: 'home', builder: (context, state) => HomePage()),
          GoRoute(path: '/stadistics', name: 'statistics', builder: (context, state) => Stadistics()),
          GoRoute(path: '/admin-book', name: 'admin-book', builder: (context, state) => AdminTodoPage()),
        ]
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
