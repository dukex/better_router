import 'package:better_router/better_router.dart';
import 'package:flutter/material.dart';

final routes = {
  '/': (context) => Column(children: [
        Text('root page'),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, "/books"),
            child: Text("Books"))
      ]),
  '/books': (context) => Column(children: [
        for (var i = 0; i < books.length; i++)
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/books/${books[i].id}"),
              child: Text(books[i].name))
      ]),
  r"\/books\/(?<id>.+)": (context) {
    final params =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    return Column(
      children: [Text('book page'), Text("Book ID: ${params['id']}")],
    );
  },
  '-matchAll': (_) => Text('not found page'),
};

void main() {
  final betterRoutes = BetterRouter(routes: routes);

  runApp(MaterialApp(onGenerateRoute: betterRoutes));
}

final books = [
  const Book(id: '3160', name: 'The Odyssey', author: 'Homer'),
  const Book(id: '8795', name: 'The Divine Comedy', author: 'Dante Alighieri'),
];

class Book {
  final String id;
  final String name;
  final String author;

  const Book({required this.id, required this.name, required this.author});
}
