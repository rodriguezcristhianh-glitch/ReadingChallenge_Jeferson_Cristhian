import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';
import 'package:proyecto_final/src/widgets/LinearProgress.dart';
//import 'package:proyecto_final/src/views/admin_book_page.dart';
//import 'package:proyecto_final/src/models/book.dart';
//import 'package:proyecto_final/src/shared/utils.dart';
//import 'package:proyecto_final/src/widgets/item_list.dart';

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

          final books = snapshot.data ?? [];

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,

            children: List.generate(books.length, (index)
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
                          Text('${books[index].title}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          Text('${books[index].author}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),

                          Row(
                            children: [
                              Text('Progress'),
                              SizedBox(width: 20),
                              
                              Column
                              (
                                children: 
                                [
                                  Text('${books[index].currentPage}/${books[index].totalPages}'),
                                  LinearProgres(value: 220, min: 1, width: 80, heightBar: 1),
                                ],
                              )
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
          );
      }),

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