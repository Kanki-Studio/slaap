import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/chat/chat_bubble.dart';
import 'package:slaap/components/dialog/confirm_dialog.dart';
import 'package:slaap/components/settings/settings_item.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/chat_message.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';

class ChatMessageDialog extends ConsumerStatefulWidget {
  final Chat chat;
  final ChatMessage message;

  const ChatMessageDialog({
    super.key,
    required this.chat,
    required this.message,
  });

  @override
  ConsumerState<ChatMessageDialog> createState() => _ChatMessageDialog();
}

class _ChatMessageDialog extends ConsumerState<ChatMessageDialog> {
  bool showOriginal = false;

  void toggleOriginal() {
    setState(() {
      showOriginal = !showOriginal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final localTransation =
        ref.watch(ChatProvider.provider).translateMessageLocal(
              message: widget.message,
              chat: widget.chat,
              currentAccount: currentAccount,
            );
    final originalLang = SupportedLang.displayName(widget.message.lang);
    final translatedLang = localTransation.to;
    final isFromCurrentAccount = widget.message.senderId == currentAccount.id;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatBubble(
            chat: widget.chat,
            message: widget.message,
            isFromCurrentAccount: isFromCurrentAccount,
            isGroupHead: false,
            isGroupTail: true,
            showContextMenu: false,
            showOriginal: showOriginal,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: isFromCurrentAccount
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  showOriginal
                      ? "Viewing original in $originalLang"
                      : "Viewing translated in $translatedLang",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            child: SettingsItemGroup(
              subtitle: "Message info",
              children: [
                SettingsItem(
                  text: "Retranslate",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmDialog(
                          title:
                              "Are you sure you want to retranslate this message?",
                          description:
                              "This will retranslate from $originalLang to $translatedLang",
                          onConfirm: () {
                            ref.read(ChatProvider.provider).dropTranslation(
                                lang: translatedLang,
                                messageId: widget.message.id,
                                chatId: widget.chat.id);
                          },
                        );
                      },
                    );
                  },
                ),
                SettingsItem(
                  text: showOriginal ? "View translated" : "View original",
                  onPressed: toggleOriginal,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
