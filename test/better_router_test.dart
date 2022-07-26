import 'package:better_router/better_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BetterRouter betterRoutes;

  final books = [
    const Book(id: '3160', name: 'The Odyssey', author: 'Homer'),
    const Book(
        id: '8795', name: 'The Divine Comedy', author: 'Dante Alighieri'),
  ];

  betterRoutes = BetterRouter(routes: {
    '/': DefaultPageRouteBuilder((context) => Column(children: [
          Text('root page'),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, "/books"),
              child: Text("Books")),
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/custom_route_transition"),
              child: Text("Custom Route"))
        ])),
    '/home': DefaultPageRouteBuilder((_) => Text('home page')),
    '/books': DefaultPageRouteBuilder((context) => Column(children: [
          for (var i = 0; i < books.length; i++)
            TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/books/${books[i].id}"),
                child: Text(books[i].name))
        ])),
    r"\/books\/(?<id>.+)": DefaultPageRouteBuilder((context) {
      final params = RouteParams.of(context);

      return Column(
        children: [Text('book page'), Text("Book ID: ${params['id']}")],
      );
    }),
    '/custom_route_transition': (RouteSettings settings) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Text("Custom route page"),
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
    '-matchAll': DefaultPageRouteBuilder((_) => Text('not found page')),
  });

  testWidgets('navigates to root page by default', (tester) async {
    await tester.pumpWidget(MaterialApp(onGenerateRoute: betterRoutes));

    final textFinder = find.text("root page");
    expect(textFinder, findsOneWidget);
    final textWidget = tester.element(textFinder).widget as Text;
    expect(textWidget.data, "root page");
  });

  testWidgets('respects the initialRoute', (tester) async {
    await tester.pumpWidget(
        MaterialApp(initialRoute: '/home', onGenerateRoute: betterRoutes));

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);
    final textWidget = tester.element(textFinder).widget as Text;
    expect(textWidget.data, "home page");
  });

  testWidgets('navigates using Navigator', (tester) async {
    await tester.pumpWidget(MaterialApp(onGenerateRoute: betterRoutes));

    final button = find.text("Books");
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final textFinder = find.text(books[0].name);
    expect(textFinder, findsOneWidget);
  });

  testWidgets('navigates send params', (tester) async {
    await tester.pumpWidget(
        MaterialApp(initialRoute: '/books', onGenerateRoute: betterRoutes));

    final book = books[0];

    final bookFinder = find.text(book.name);
    expect(bookFinder, findsOneWidget);

    await tester.tap(bookFinder);
    await tester.pumpAndSettle();

    final bookIdFinder = find.text("Book ID: ${book.id}");
    expect(bookIdFinder, findsOneWidget);
  });

  testWidgets('navigates using custom route', (tester) async {
    await tester.pumpWidget(
        MaterialApp(initialRoute: '/', onGenerateRoute: betterRoutes));

    final buttonFinder = find.text("Custom Route");

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    final pageTextFinder = find.text("Custom route page");
    expect(pageTextFinder, findsOneWidget);
  });

  testWidgets('renders -matchAll when not found', (tester) async {
    await tester.pumpWidget(
        MaterialApp(initialRoute: '/not_found', onGenerateRoute: betterRoutes));

    final textFinder = find.text("not found page");
    expect(textFinder, findsOneWidget);
  });
}

class Book {
  final String id;
  final String name;
  final String author;

  const Book({required this.id, required this.name, required this.author});
}
