import 'package:flutter/material.dart';

class RouteParams {
  static Map<String, String?> of(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
}
