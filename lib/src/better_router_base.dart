import 'package:flutter/material.dart';

import 'route_info.dart';
import 'matcher.dart';

/// The BetterRouter class are resposible create the routing table and the route generator.
///
/// To simple routes is better use the routes params in [MaterialApp]:
///
///       BetterRouter(routes: {
///         "/": (_)=> SomeScreen();
///       })
///
/// The good use case to BetterRouter is complex routes with params in path.
///
///       BetterRouter(routes: {
///         r"\/books\/(?<id>.+)": (context) {
///           final params =
///             ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
///
///           return Text("Book ID: ${params['id']}")]
///         };
///       })
class BetterRouter {
  /// The application's top-level routing table.
  ///
  /// When a named route is pushed with [Navigator.pushNamed], the route name is
  /// looked up in this map. If the name is present, the associated
  /// [widgets.WidgetBuilder] is used to construct a [MaterialPageRoute] that
  /// performs an appropriate transition, including [Hero] animations, to the
  /// new route.
  ///
  /// The main difference from [MaterialApp] routes, it the possibility to use
  /// Named Regex group and receive it as [RouteSettings] in the [Widget]
  final Map<String, WidgetBuilder> routes;

  /// Create a new [BetterRouter] instance with the given [routes]
  BetterRouter({required this.routes}) : assert(routes['-matchAll'] != null);

  /// The [call] method should be used as [RouteFactory], per exemple, in the
  /// [MaterialApp.onGenerateRoute] or [MaterialApp.onUnknownRoute] params.
  Route<dynamic> call(RouteSettings settings) {
    final String path = settings.name!;

    RouteInfo routeInfo = _routeInfo(path);

    final WidgetBuilder pageContentBuilder = routes[routeInfo.path]!;

    final Route<dynamic> route = _pageRouteBuilder<dynamic>(
      settings.copyWith(arguments: routeInfo.data),
      pageContentBuilder,
    );

    return route;
  }

  RouteInfo _routeInfo(path) => _mapped.putIfAbsent(
      path,
      () => _mapper.map((m) => m.matchWith(path)).lastWhere(
            (element) => element != null,
            orElse: () => RouteInfo(path: "-matchAll", data: {}),
          )!);

  _pageRouteBuilder<T>(RouteSettings settings, WidgetBuilder builder) =>
      MaterialPageRoute<T>(settings: settings, builder: builder);

  Iterable<Matcher> get _mapper =>
      routes.keys.map((path) => Matcher(path, RegExp("^$path\$")));

  final _mapped = <String, RouteInfo>{};
}
