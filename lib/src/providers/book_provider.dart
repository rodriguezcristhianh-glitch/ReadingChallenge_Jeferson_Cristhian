/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_app/src/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookProvider 
{
  Future<List<Book>> getAllBooks() async
  {
    final db = FirebaseFirestore.instance;
    final collectionRefBooks = db.collection('books');
    final snapshotBooks = await collectionRefBooks.get();

    final books = List<Book>.from
    (
      snapshotBooks.docs.map
      (
        (book) 
        {
          return Book.fromJson({'id': book.id, ...book.data()});
        }
      )
    );
    return books;
  }
}*/