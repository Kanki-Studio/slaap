import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/avatar.dart';
import 'package:slaap/components/dialog/confirm_dialog.dart';
import 'package:slaap/components/lang/lang_picker.dart';
import 'package:slaap/components/settings/settings_item.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/auth.dart';
import 'package:slaap/providers/onboarding.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final receiveLang = SupportedLang.displayName(currentAccount.lang.receive);
    final sendLang = SupportedLang.displayName(currentAccount.lang.send);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Avatar(size: 64, photoURL: currentAccount.photoURL),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentAccount.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(currentAccount.email),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),
              SettingsItemGroup(
                subtitle: "Language",
                children: [
                  SettingsItem(
                    text: "Send ($sendLang)",
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return LangPicker(
                            title: "Select language",
                            selected: currentAccount.lang.send,
                            onSelect: (lang) async {
                              try {
                                await ref
                                    .watch(AccountProvider.provider)
                                    .updateLanguage(
                                      lang: Lang(
                                        send: lang.value,
                                        receive: currentAccount.lang.receive,
                                      ),
                                      currentAccount: currentAccount,
                                    );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        const Text("Failed to update language"),
                                    action: SnackBarAction(
                                      label: "Ok",
                                      onPressed: () {},
                                    ),
                                  ));
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                  SettingsItem(
                    text: "Receive ($receiveLang)",
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return LangPicker(
                            title: "Select language",
                            selected: currentAccount.lang.receive,
                            onSelect: (lang) async {
                              try {
                                await ref
                                    .watch(AccountProvider.provider)
                                    .updateLanguage(
                                      lang: Lang(
                                        send: currentAccount.lang.send,
                                        receive: lang.value,
                                      ),
                                      currentAccount: currentAccount,
                                    );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        const Text("Failed to update language"),
                                    action: SnackBarAction(
                                      label: "Ok",
                                      onPressed: () {},
                                    ),
                                  ));
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingsItemGroup(
                subtitle: "More",
                children: [
                  SettingsItem(
                    text: "Logout",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog(
                            title: "Are you sure you want to logout?",
                            onConfirm: () {
                              ref.read(AuthProvider.provider).signOut();
                            },
                          );
                        },
                      );
                    },
                  ),
                  SettingsItem(
                    text: "Reset",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog(
                            title: "Are you sure you want to continue?",
                            description:
                                "You will be logged out and redirected to the onboarding screen",
                            onConfirm: () {
                              ref.read(AuthProvider.provider).signOut();
                              ref
                                  .read(OnBoardingProvider.provider.notifier)
                                  .reset();
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
