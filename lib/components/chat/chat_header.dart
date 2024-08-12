import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/avatar.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/providers/account.dart';

class ChatHeader extends ConsumerWidget {
  final Chat chat;

  const ChatHeader({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final accountId = chat.accounts.keys.reduce(
      (value, element) => element != currentAccount.id ? element : value,
    );
    final account = ref.watch(AccountProvider.getAccountProvider(accountId));

    return Row(
      children: [
        Avatar(size: 40, photoURL: account.valueOrNull?.photoURL),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.when(
                data: (data) => data.id == currentAccount.id
                    ? "${data.name} (You)"
                    : data.name,
                error: (e, s) => "Unknown",
                loading: () => "loading...",
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              account.when(
                data: (data) => data.email,
                error: (e, s) => "Error",
                loading: () => "failed to fetch account",
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
