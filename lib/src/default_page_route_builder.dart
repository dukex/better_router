import 'package:flutter/material.dart';

class DefaultPageRouteBuilder<T> {
  final WidgetBuilder builder;

  DefaultPageRouteBuilder(this.builder);

  PageRoute call(RouteSettings settings) =>
      MaterialPageRoute<T>(settings: settings, builder: builder);
}
