import 'package:flutter/material.dart';

class HomePage extends StatefulWidget 
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                CircleAvatar(backgroundColor: Colors.amber[50],)
              ],
              )),

            ListTile(leading: Icon(Icons.home), title: Text('Inicio', style: TextStyle(color: Colors.black)))
          ],
          
        ),

        
      ),

      appBar: AppBar(
        title: const Text('Lectura'),
      ),
    );
  }
}