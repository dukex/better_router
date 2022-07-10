import 'package:flutter/material.dart';

import 'route_info.dart';
import 'matcher.dart';

class BetterRouter {
  final Map<String, WidgetBuilder> routes;

  BetterRouter({required this.routes}) : assert(routes['-matchAll'] != null);

  pageRouteBuilder<T>(RouteSettings settings, WidgetBuilder builder) {
    return MaterialPageRoute<T>(settings: settings, builder: builder);
  }

  Route<dynamic>? call(RouteSettings settings) {
    final String path = settings.name!;

    RouteInfo routeInfo = _routeInfo(path);

    final WidgetBuilder pageContentBuilder = routes[routeInfo.path]!;

    final Route<dynamic> route = pageRouteBuilder<dynamic>(
      settings.copyWith(arguments: routeInfo.data),
      pageContentBuilder,
    );

    return route;
  }

  Iterable<Matcher> get _mapper =>
      routes.keys.map((path) => Matcher(path, RegExp("^$path\$")));

  final _mapped = <String, RouteInfo>{};

  RouteInfo _routeInfo(path) => _mapped.putIfAbsent(
      path,
      () => _mapper.map((m) => m.matchWith(path)).lastWhere(
            (element) => element != null,
            orElse: () => RouteInfo(path: "-matchAll", data: {}),
          )!);
}
