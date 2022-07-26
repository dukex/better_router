## 2.0.0

### BREAKING CHANGES

Before this version the routes was:
```
final Map<String, WidgetBuilder> routes;
```
 
Now the routes are:
```
 final Map<String, PageRouteBuilder> routes;
```

### Feature

- [Add ability to use custom transition](https://github.com/dukex/better_router/commit/00dedae3a1a37365209d6ac3e117bc7acf895e1f) - The `DefaultPageRouteBuilder` will use the `MaterialPageRoute`, but now you can implement your transition using your [`PageRouteBuilder`](https://github.com/dukex/better_router/commit/00dedae3a1a37365209d6ac3e117bc7acf895e1f#diff-a36c9b11e73e4ebd500e1f1b48a515840096cc5ca0578beebc88af4ab287cb22R6)


## 1.0.0

- Initial version.
