MapEntry<K, U> Function(K, V) mapValue<K, V, U>(
  U Function(V value) transform,
) {
  return (key, value) => MapEntry(key, transform(value));
}

String formatTime(DateTime date) {
  bool isPm = date.hour > 12;
  String hour = isPm ? "${date.hour - 12}" : "${date.hour}";
  String minute = date.minute.toString().padLeft(2, "0");
  return "$hour:$minute ${isPm ? "PM" : "AM"}";
}
