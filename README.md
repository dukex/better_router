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
    '/': (context) => Column(children: [
          Text('root page'),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, "/books"),
              child: Text("Books"))
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
    '*matchAll': (_) => Text('not found page'),
  });

  runApp(MaterialApp(onGenerateRoute: betterRoutes));
}
```