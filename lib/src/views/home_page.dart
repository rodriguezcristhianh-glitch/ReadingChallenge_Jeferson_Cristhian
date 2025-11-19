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

      body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) 
          {
            return Card(
              child: ListTile
              (
                leading: const Icon(Icons.book, color: Color.fromARGB(255, 119, 93, 20)),
                title: Text('Book Title $index'),
                subtitle: const Text('Author Name'),
              ),
            );
          },

          /*title: const Text('Books', 
            style: TextStyle(color: Colors.black, 
            fontWeight: FontWeight.bold)),*/

        
      ),
    );
  }
}