import 'package:better_router/better_router.dart';
import 'package:flutter/material.dart';

final routes = <String, PageRoute<dynamic> Function(RouteSettings)>{
  '/': DefaultPageRouteBuilder((context) => Column(children: [
        Text('root page'),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, "/books"),
            child: Text("Books")),
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/this_page_does_not_exists"),
            child: Text("Go to not found page")),
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/custom_route_transition"),
            child: Text("Go to custom transition"))
      ])).call,
  '/books': DefaultPageRouteBuilder((context) => Column(children: [
        for (var i = 0; i < books.length; i++)
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/books/${books[i].id}"),
              child: Text(books[i].name))
      ])).call,
  r"\/books\/(?<id>.+)": DefaultPageRouteBuilder((context) {
    final params = RouteParams.of(context);

    return Column(
      children: [Text('book page'), Text("Book ID: ${params['id']}")],
    );
  }).call,
  '/custom_route_transition': (RouteSettings settings) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Text("Transition"),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      }),
  '-matchAll': DefaultPageRouteBuilder((_) => Text('not found page')).call,
};

void main() {
  final betterRoutes = BetterRouter(routes: routes);

  runApp(MaterialApp(onGenerateRoute: betterRoutes.call));
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
