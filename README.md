A powerful, but for humans, flutter router

## Features

- Static routes
- Dynamic routes
- Catch All

## Getting started

```
$ flutter pub add better_router
```

## Usage


```dart
void main() {
  final books = [
    const Book(id: '3160', name: 'The Odyssey', author: 'Homer'),
    const Book(
        id: '8795', name: 'The Divine Comedy', author: 'Dante Alighieri'),
  ];

  final betterRoutes = BetterRouter(routes: {
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
      final params =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

      return Column(
        children: [Text('book page'), Text("Book ID: ${params['id']}")],
      );
    }),
    '/custom_route_transition': (RouteSettings settings) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Text("Transition \o/"),
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
    '*matchAll': PageRouteBuilder((_) => Text('not found page')),
  });

  runApp(MaterialApp(onGenerateRoute: betterRoutes));
}
```