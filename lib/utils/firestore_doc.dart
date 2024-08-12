import 'package:cloud_firestore/cloud_firestore.dart';

T? Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore<T>(
  T Function(Map<String, dynamic>) fn,
) {
  return (snapshot) {
    final data = snapshot.data();
    return data != null ? fn(data..addAll({"id": snapshot.id})) : null;
  };
}

Iterable<T> Function(QuerySnapshot<Map<String, dynamic>>) fromFirestoreQuery<T>(
  T Function(Map<String, dynamic>) fn,
) {
  return (snapshot) {
    return snapshot.docs.map((doc) => fn(doc.data()..addAll({"id": doc.id})));
  };
}

Map<String, dynamic> toFirestore(Map<String, dynamic> Function() fn) {
  return fn()..remove("id");
}
