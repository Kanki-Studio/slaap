import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String? photoURL;

  const Avatar({
    super.key,
    required this.size,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    final nphotoURL = photoURL;
    return nphotoURL != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.network(
              nphotoURL,
              width: size,
              height: size,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: SizedBox(width: size, height: size),
          );
  }
}
