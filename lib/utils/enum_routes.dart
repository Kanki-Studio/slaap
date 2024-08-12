abstract class EnumPath {
  final String path;

  const EnumPath({required this.path});
}

class EnumRoutes<T extends EnumPath> {
  final List<T> routes;

  const EnumRoutes({required this.routes});

  String $path(T route, {T? parent}) {
    if (parent != null) {
      final stripped = route.path.replaceFirst("${parent.path}/", '');
      if (stripped == route.path) {
        throw Exception("Route $parent is not a parent of $route");
      }
      return stripped;
    }
    return route.path;
  }

  String $destination(T route, {Map<String, String>? params}) {
    String destination = route.path;
    if (params != null) {
      for (final entry in params.entries) {
        destination = destination.replaceFirst(":${entry.key}", entry.value);
      }
    }
    assert(
      !destination.contains(":"),
      "Route destination contains missing params",
    );
    return destination;
  }

  T? $fromPath(String? path) {
    return routes.where((e) => e.path == path).firstOrNull;
  }
}
