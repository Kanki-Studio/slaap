import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/router.dart';

class ChatPage extends StatelessWidget {
  final String id;

  const ChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ChatHeader(),
        actions: [
          IconButton.outlined(
            icon: const Icon(Icons.settings, size: 22),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: () {
              context.push(Routes.chatSettings(id).path);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  index = 19 - index;
                  final isLast = index == 20 - 1;
                  final isSent = (index % 10) + 4 > 6;
                  final isPrevSent = ((index - 1) % 10) + 4 > 6;
                  final isLeader = !isPrevSent || index == 0;

                  return ChatMessage(
                    chatId: id,
                    messageId: index.toString(),
                    isLeader: isLeader,
                    isLast: isLast,
                    isSent: isSent,
                  );
                },
              ),
            ),
            // message input
            ChatInput(id: id)
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.chatId,
    required this.messageId,
    required this.isLeader,
    required this.isLast,
    required this.isSent,
  });

  final String chatId;
  final String messageId;
  final bool isLeader;
  final bool isLast;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: !isLeader ? 6 : 12, bottom: isLast ? 12 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: GestureDetector(
            onLongPress: () {
              context.push(Routes.chatMessage(chatId, messageId).path);
            },
            onDoubleTap: () {
              PersistentBottomSheetController? controller;
              controller = showBottomSheet(
                  showDragHandle: true,
                  constraints: const BoxConstraints(maxHeight: 400),
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Hello"),
                          MaterialButton(
                            child: const Text("Close"),
                            onPressed: () {
                              controller?.close();
                            },
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isSent ? Colors.blueAccent.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    !isSent && isLeader ? 0 : 14,
                  ),
                  topRight: Radius.circular(
                    isSent && isLeader ? 0 : 14,
                  ),
                  bottomRight: const Radius.circular(14),
                  bottomLeft: const Radius.circular(14),
                ),
              ),
              child: Text(
                "Perfect! when can we start with cardio and then move on? $messageId",
                style: TextStyle(
                  fontSize: 15,
                  color: isSent ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const SizedBox(width: 40, height: 40),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Online",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.add_rounded, size: 22),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                maxLines: 4,
                minLines: 1,
                cursorHeight: 18,
                decoration: InputDecoration(
                  hintText: "Enter message",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  isDense: true,
                ),
              ),
            ),
            IconButton.filled(
              icon: const Icon(Icons.arrow_upward_rounded, size: 22),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
