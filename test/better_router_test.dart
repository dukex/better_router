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
    '/': (context) => Column(children: [
          Text('root page'),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, "/books"),
              child: Text("Help"))
        ]),
    '/home': (_) => Text('home page'),
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

    final button = find.byType(TextButton);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final textFinder = find.text(books[0].name);
    expect(textFinder, findsOneWidget);
  });

  testWidgets('navigates send arguments', (tester) async {
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
