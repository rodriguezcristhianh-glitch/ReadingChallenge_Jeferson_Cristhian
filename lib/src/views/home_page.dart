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
      endDrawer: Drawer
      (
        child: DrawerHeader
        (
          padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 15),
          child: ListView
          (
            children: 
            [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: 
                [
                  Row(
                    children: 
                    [
                          CircleAvatar(backgroundColor: const Color.fromARGB(255, 153, 196, 192), radius: 35, foregroundColor: Colors.black),
                          SizedBox(width: 12),
                          Text('Jeferson Reyes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.logout, size: 16, color: Colors.grey[600]),
                        ]
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: 
                        [
                          Text('Achievements:', style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                          Column
                          (
                            children: 
                            [
                              Text('Max. Page: 120 minutes', style: TextStyle(fontSize: 14),),
                              Text('Books read: 20', style: TextStyle(fontSize: 14),),
                              Text('Maximum streak: 15 days', style: TextStyle(fontSize: 14),),
                            ]
                          )
                          
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                  ListTile(leading: Icon(Icons.home), title: Text('Inicio', style: TextStyle(color: Colors.black))),
                  ListTile(leading: Icon(Icons.accessibility), title: Text('Accessibility')),
                ]
              ),
        ),
      ),

      appBar: AppBar
      (
        title: const Text('Books', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      
      body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) 
          {
            return Card(
              child: ListTile
              (
                leading: const Icon(Icons.book_sharp, color: Color.fromARGB(255, 97, 77, 23)),
                title: Text('Book Title ${index+1}'),
                subtitle: const Text('Author Name'),
                trailing: const Icon(Icons.linear_scale, fill: 0.2, grade: 0.6,),
              ),
            );
          },

          /*title: const Text('Books', 
            style: TextStyle(color: Colors.black, 
            fontWeight: FontWeight.bold)),*/

        
      ),
      floatingActionButton: FloatingActionButton
      (
        onPressed: () => setState(() {
          //_count++;
        }),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber[50],
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        notchMargin: 1,
        child: Container
        (
          child: const Text('Menu'),
        ),
      ),
    );
  }
}