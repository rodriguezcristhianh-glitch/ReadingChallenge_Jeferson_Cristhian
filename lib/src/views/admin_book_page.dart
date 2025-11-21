import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/api/books.dart';
import 'package:proyecto_final/src/shared/utils.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';

class AdminTodoPage extends StatefulWidget 
{
  AdminTodoPage({super.key, this.book});

  final Map<String, dynamic>? book;

  @override
  State<AdminTodoPage> createState() => _AdminTodoPageState();
}

class _AdminTodoPageState extends State<AdminTodoPage> {
  final titleController = TextEditingController();

  final autorController = TextEditingController();
  final estadoController = TextEditingController();

  final FocusNode titleFocus = FocusNode();

  final bookProvider = BookProvider();

  @override
  Widget build(BuildContext context) {
    //Id que me permite consultar a la BBDD la información actualziada
    final bookId = GoRouterState.of(context).pathParameters['id'];

    //Lista de Estados
    final List<String>_listEstado = ['Pendiente', 'Finalizado','En progreso'];
    String? _selectedEstado;
    List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
      return _listEstado.map((String estado) {
        return DropdownMenuItem<String>(
          value: estado,
          child: Text(estado),
        );
      }).toList();
    }

    if (widget.book != null) {
      titleController.text = widget.book!['title'];
      autorController.text = widget.book!['autor'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book == null
              ? 'Agregando nuevo libro'
              : 'Editando el progreso del libro # $bookId',
        ),
      ),
      body: SingleChildScrollView (
        padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
        
        child: Column(
          children: [
            //codigo donde hacemos stack el floating action button con el Image
            Stack(
              children: [
                Image(image: NetworkImage("https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg")),
                Positioned(
                  bottom: 10,
                  left: 150,

                  child: 
                  FloatingActionButton(onPressed: (){

                      },
                      foregroundColor: Colors.black,
                      backgroundColor:Colors.white, 

                      child: Icon(Icons.add_photo_alternate),
            
            
            ),
                )
              ],

            ),
            
            SizedBox(height: 16),
            TextField(
              focusNode: titleFocus,
              controller: titleController,
              decoration: InputDecoration(
                label: Text('Titulo'),
                hint: Text('Eje. Crear opción de eliminar'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                // suffixIcon: IconButton(
                //   icon: Icon(Icons.visibility),
                //   onPressed: () {},
                // ),
                prefixIcon: Icon(Icons.text_fields_rounded),
              ),

              maxLines: 1,
              maxLength: 50,
              obscureText: false,
              keyboardType: TextInputType.visiblePassword,
              // style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            TextField(
              controller: autorController,
              maxLines: 1,
              decoration: InputDecoration(
                label: Text('Autor'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person),
                ),
            ),
            SizedBox(height: 16),

            //Implementacion del DropdownButtonFormField para la seleccion de estados.
            DropdownButtonFormField<String>(
                initialValue: _selectedEstado, 
                items: _buildDropdownMenuItems(), 
                onChanged: (String? newValue) {
                      setState(() {
                      _selectedEstado = newValue; 
                });
                },
                    decoration: InputDecoration(
                      labelText: 'Estado', 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.update_rounded), 
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Porfavor selecciona un Estado'; // Optional validation
                      }
                      return null;
                    },
    )
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () async {
          if (titleController.text.isEmpty) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       'Debe ingresar un titulo',
            //       style: TextStyle(color: Colors.red[50]),
            //     ),
            //     backgroundColor: Colors.red,
            //   ),
            // );

            Utils.showSnackBar(
              context: context,
              title: "El titulo es obligatorio",
              color: Colors.red,
            );

            return;
          }

          final Map<String, dynamic> newTodo = {
            'title': titleController.text,
            'autor': autorController.text,
            'completed': false,
            'user': FirebaseAuth.instance.currentUser?.uid,
          };

          if (bookId == null) {
            // todoList.add(newTodo);
            // mostrar icono de carga
            await bookProvider.saveBook(newTodo);

            // ocultar icono de carga
          } else {
            final indice = booksList.indexWhere(
              (todo) => todo['id'].toString() == bookId,
            );

            booksList[indice] = newTodo;
          }

          // final snackBar = SnackBar(
          //   content: const Text('Yay! A SnackBar!'),
          //   action: SnackBarAction(
          //     label: 'Undo',
          //     onPressed: () {
          //       // Some code to undo the change.
          //     },
          //   ),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Tarea creada correctamente'),
          //     // backgroundColor: ,
          //     duration: Duration(days: 4),
          //     action: SnackBarAction(label: 'Cerrar', onPressed: () {}),
          //   ),
          // );

          if (!context.mounted) return;

          Utils.showSnackBar(
            context: context,
            title: "Libro añadido correctamente",
          );

          titleController.text = '';
          autorController.text = '';

          context.pop();
        },
        child: Icon(Icons.add, color: Colors.blue[50]),
      ),
    );
  }
}