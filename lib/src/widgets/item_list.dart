import 'package:flutter/material.dart';
import 'package:proyecto_final/src/models/book.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';

class ItemList extends StatelessWidget {
  ItemList({super.key, required this.book});

  final provider = BookProvider();
  final Book book;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        book.title,
        style: TextStyle(
          decoration: book.status.name == 'Finalizado'
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(book.author ?? ''),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Icon(
          book.status == 'Finalizado' ? Icons.check_rounded : Icons.calendar_month_outlined,
          color: Colors.blue[800],
        ),
      ),
      trailing: Checkbox(
        checkColor: Colors.blue,
        activeColor: Colors.blue[100],
        value: book.status == 'Finalizado',
        onChanged: (value) async {
          // setState(() {});

          final result = await provider.markAsComplete(
            docId: book.id,
            value: value ?? false,
          );
          // if (result)
          // todo.completed = value ?? false;
        },
      ),
    );
  }
}