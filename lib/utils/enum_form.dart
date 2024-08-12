import 'package:flutter/widgets.dart';

class EnumForm<T extends Enum> {
  final Map<T, TextEditingController> controllers;

  EnumForm({
    required List<T> fields,
    Map<T, TextEditingController>? initial,
  }) : controllers = Map.fromEntries(
          fields
              .map((e) => MapEntry(e, initial?[e] ?? TextEditingController())),
        );

  Iterable<MapEntry<T, TextEditingController>> get fields {
    return controllers.entries;
  }

  TextEditingController controller(T field) {
    return controllers[field]!;
  }

  String value(T field) {
    return controller(field).text;
  }

  Map<T, String> values() {
    return controllers.map((key, value) => MapEntry(key, value.text));
  }

  String? error(T field) {
    return null;
  }

  Map<T, String?> errors() {
    return controllers.map((key, value) => MapEntry(key, error(key)));
  }

  bool hasErrors() {
    return controllers.entries.any((e) => error(e.key) != null);
  }

  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
  }
}
