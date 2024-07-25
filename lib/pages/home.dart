import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: Expanded(
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return ChatItem(
              id: index,
              title: "User $index",
              preview: "See more messages",
            );
          },
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  static const double _iconWidth = 56;
  static const double _iconPadding = 7;

  final int id;
  final String title;
  final String preview;

  const ChatItem({
    super.key,
    required this.id,
    required this.title,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/chat/$id");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(_iconWidth / 2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(_iconPadding),
                    child: Icon(
                      Icons.person,
                      size: _iconWidth - (_iconPadding * 2),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // title and preview
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(preview,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),

            // timestamp
            const Text("4:30"),
          ],
        ),
      ),
    );
  }
}
