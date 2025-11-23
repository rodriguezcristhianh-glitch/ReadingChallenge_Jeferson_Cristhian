import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';
import 'package:proyecto_final/src/widgets/LinearProgress.dart';
import 'package:proyecto_final/src/views/admin_book_page.dart';

class HomePage extends StatefulWidget 
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  final bookProvider = BookProvider();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() 
  {
    super.initState();
    initMessaging();
  }

  initMessaging() async
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("User granted permission: ${settings.authorizationStatus}");

    final token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) 
  {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['page'] && context.mounted) {
        context.goNamed(message.data['page']);
      }
    });

    return Scaffold
    (
      endDrawer: Drawer
      (
        width: 320,
        child: DrawerHeader
        (
          padding: EdgeInsetsGeometry.symmetric(vertical: 35, horizontal: 10),
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
                        backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL == null ? 'user.png' : '${FirebaseAuth.instance.currentUser?.photoURL}'),
                          //backgroundColor: const Color.fromARGB(255, 153, 196, 192), 
                          radius: 35, 
                          foregroundColor: Colors.black,
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 170,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: 
                        [
                          Text('${FirebaseAuth.instance.currentUser?.email}', style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('${FirebaseAuth.instance.currentUser?.displayName}', style:  TextStyle(fontSize: 12)),
                        ]
                      ),
                      ),
                      
                      IconButton(
                        icon: Icon(Icons.logout, size: 15, color: Colors.grey[600]),
                        splashColor: Colors.red[400],
                        hoverColor: Colors.red[400],
                        onPressed: () async 
                        { 
                          await FirebaseAuth.instance.signOut();
                          print('Current user: ${FirebaseAuth.instance.currentUser}');
                          if (!context.mounted) return;
                              
                          context.replace('/login');
                        },
                      ),
                    ]
                  ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: 
                        [
                          Text('Achievements:', style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                          Column
                          (
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
        //backgroundColor: const Color.fromARGB(255, 235, 235, 233), 
        elevation: 0.2,
        shadowColor: Color(0xFFE5E5E5),
      ),

      body: GridView.count
      (
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: List.generate(12, (index) 
        {
          return GestureDetector
          (
            onTap: () 
            {
              // Acción al tocar la tarjeta
              // 1. Navegar a la pagina de detalles del libro y mostrar el cronometro
            },
            child: Card
            (
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: 
                [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(image: AssetImage('assets/maestria_cover.webp'), width: 80, height: 80,),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
                    ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text('Book ${index + 1}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 3),
                      Text('Author Name', style: TextStyle(fontSize: 14, color: Colors.grey[600])),

                      Row(
                        children: [
                          Text('Progress'),
                          SizedBox(width: 20),
                          
                          Column(
                            children: [
                              Text('110/220'),
                              LinearProgres(value: 220, min: 1, width: 80, heightBar: 1),
                            ],
                          )
                        ],
                      ),
                      
                    ],
                  ),
                  //Icon(Icons.book, size: 50, color: Colors.blueAccent),
                  
                ],
              ),
            ),
          );
        }),
      ),

/*
      body: StreamBuilder
      (
        stream: bookProvider.getAllBooksStream(), 
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay libros registrados aún.'));
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
                      'update-book',
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
                          .collection('books')
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
                child:  ItemList(book: books[index]),
              );
            },
          );

          // información de todo lo que ocurre con el future
        },
      ),
*/



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
        heroTag: 'tag_admin_book',
        backgroundColor: Colors.blue[300],
        onPressed: () 
        {
          context.pushNamed('admin-book');
        },

        child: const Icon(Icons.add),
      ),
      
      bottomNavigationBar: BottomAppBar
      (
        height: 40,
        color: const Color.fromARGB(255, 247, 247, 244),
        shadowColor: Colors.black,
        
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Color.fromARGB(255, 51, 51, 51), size: 28, shadows: [Shadow(color: Color.fromARGB(255, 248, 211, 4), blurRadius: 1.2)],),
              onPressed: () {context.go( '/home' );},
            ),
            IconButton(
              icon: const Icon(Icons.line_axis_rounded, color: Colors.black, size: 28,),
              onPressed: () {context.go( '/stadistics' );},
            ),
          ],
        ),
      ),
    );
  }
}