import 'package:go_router/go_router.dart';
import 'package:slaap/layouts/tabs_layout.dart';
import 'package:slaap/pages/chat.dart';
import 'package:slaap/pages/chat_message.dart';
import 'package:slaap/pages/chat_settings.dart';
import 'package:slaap/pages/home.dart';
import 'package:slaap/pages/settings.dart';
import 'package:slaap/pages/settings_account.dart';
import 'package:slaap/pages/start.dart';

class Routes {
  final String path;

  const Routes(this.path);

  Routes.home() : this("/");
  Routes.start() : this("/start");
  Routes.settings() : this("/settings");
  Routes.settingsProfile() : this("/settings/profile");
  Routes.chat(String id) : this("/chat/$id");
  Routes.chatSettings(String id) : this("/chat/$id/settings");
  Routes.chatMessage(String id, String messageId)
      : this("/chat/$id/messages/$messageId");

  String stripParentPath(Routes prefix) {
    final stripped = path.replaceFirst("${prefix.path}/", '');
    if (path == stripped) {
      throw Exception("Route ${prefix.path} is not a parent of $path");
    }
    return stripped;
  }
}

final GoRouter pagesRouter = GoRouter(
  routes: [
    // tabs
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home().path,
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.start().path,
              builder: (context, state) {
                return const StartPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.settings().path,
                builder: (context, state) {
                  return const SettingsPage();
                },
                routes: [
                  GoRoute(
                    path: Routes.settingsProfile()
                        .stripParentPath(Routes.settings()),
                    builder: (context, state) {
                      return const SettingsAccountPage();
                    },
                  )
                ]),
          ],
        )
      ],
      builder: (context, state, navigationShell) {
        return TabsLayout(navigationShell: navigationShell);
      },
    ),
    GoRoute(
      path: Routes.chat(":id").path,
      builder: (context, state) {
        return ChatPage(
          id: state.pathParameters["id"]!,
        );
      },
      routes: [
        GoRoute(
          path: Routes.chatSettings(":id").stripParentPath(Routes.chat(":id")),
          builder: (context, state) {
            return ChatSettingsPage(
              id: state.pathParameters["id"]!,
            );
          },
        ),
        GoRoute(
          path: Routes.chatMessage(":id", ":messageId")
              .stripParentPath(Routes.chat(":id")),
          builder: (context, state) {
            return ChatMessagePage(
              id: state.pathParameters["id"]!,
              messageId: state.pathParameters["messageId"]!,
            );
          },
        ),
      ],
    ),
  ],
);
