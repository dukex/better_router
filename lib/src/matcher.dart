import 'route_info.dart';

class Matcher {
  final String path;
  final RegExp matcher;

  const Matcher(this.path, this.matcher);

  RouteInfo? matchWith(expPath) {
    final match = matcher.firstMatch(expPath);

    if (match == null) {
      return null;
    }

    final values =
        List.generate(match.groupCount, (index) => match.group(index + 1));
    final data = Map.fromIterables(match.groupNames, values);

    return RouteInfo(path: path, data: data);
  }
}
