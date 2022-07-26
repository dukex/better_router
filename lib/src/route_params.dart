import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class RouteParams {
  static Map<String, String?> of(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
}
