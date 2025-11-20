import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';
import 'package:proyecto_final/src/models/book.dart';
import 'package:proyecto_final/src/shared/utils.dart';
import 'package:proyecto_final/src/widgets/item_list.dart';

class HomePage extends StatefulWidget 
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  final bookProvider = BookProvider();

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
                      CircleAvatar
                      (
                          backgroundColor: const Color.fromARGB(255, 153, 196, 192), 
                          radius: 35, 
                          foregroundColor: Colors.black,
                      ),
                      SizedBox(width: 12),
                      Text('Jeferson Reyes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.logout, size: 20, color: Colors.grey[600]),
                        onPressed: () async 
                        { 
                          await FirebaseAuth.instance.signOut();

                          if (!context.mounted) return;
                              
                          context.replace('/login');
                        },
                      ),
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
        backgroundColor: const Color.fromARGB(255, 235, 235, 233), 
        elevation: 10,
      ),

      body: StreamBuilder
      (
        stream: bookProvider.getAllBooksStream(), 
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) 
          {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          final List<Book> books = snapshot.data!;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                confirmDismiss: (direction) async {
                  //? Para actualizar
                  if (direction == DismissDirection.endToStart) {
                    context.pushNamed(
                      'update-todo',
                      pathParameters: {'id': books[index].id},
                      extra: books[index],
                    );
                    return false;
                  }

                  //? Para eliminar
                  return await Utils.showConfirm(
                    context: context,
                    confirmButton: () 
                    {
                      FirebaseFirestore.instance
                          .collection('todos')
                          .doc(books[index].id)
                          .delete();

                      if (!context.mounted) return;
                      context.pop(books.remove(books[index]));
                    },
                  );
                },
                onDismissed: (direction) {
                  print(direction);
                },
                background: Container(
                  padding: EdgeInsets.only(left: 16),
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red[50],
                      size: 30,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  padding: EdgeInsets.only(right: 16),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Modificar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[50],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.blue[50],
                        size: 30,
                      ),
                    ],
                  ),
                ),

                key: Key(books[index].id),
                child: ItemList(book: books[index]),
              );
            },
          );

          // información de todo lo que ocurre con el future
        },
      ),




/*
          padding: const EdgeInsets.all(8.0),
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) 
          {
            return Card(
              child: ListTile
              (
                leading: Image(image: AssetImage('assets/maestria_cover.webp'), width: 100, height: 100,),
                //const Icon(Icons.book_sharp, color: Color.fromARGB(255, 97, 77, 23)),
                title: Text('Book Title ${index+1}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: const Text('Author Name'),
                trailing: const Icon(Icons.linear_scale, fill: 0.2, grade: 0.6,),
              ),
            );
          });
        },
      ),*/
      /*
      body: ,*/

      floatingActionButton: FloatingActionButton
      (
        onPressed: () => setState(() 
        {
          FirebaseAuth.instance.signOut();
        }),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      
      bottomNavigationBar: BottomAppBar
      (
        height: 30,
        color: const Color.fromARGB(255, 247, 247, 244),
        clipBehavior: Clip.antiAlias,
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 28,),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.line_axis_rounded, color: Colors.black, size: 28,),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}