import 'package:flutter/material.dart';

enum BookStatus
{
  Pendiente, 
  EnProgreso, 
  Finalizado,
}

class Book
{
  final String id;
  final String title;
  final String author;
  final ImageProvider? coverImage;
  final BookStatus status; 

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverImage,
    required this.status,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'], 
    title: json['title'],
    author: json['author'],
    coverImage: json['coverImage'] != null ? NetworkImage(json['coverImage']) : null,
    status: json['status'],
  );

  Map<String, dynamic> toJson()
  {
    return 
    {
      'title': title,
      'author': author,
      'coverImage': coverImage != null ? (coverImage as NetworkImage).url : null,
      'status': status,
    };
  }
}