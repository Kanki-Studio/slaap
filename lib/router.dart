import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/layouts/tabs_layout.dart';
import 'package:slaap/middlewares/account.dart';
import 'package:slaap/middlewares/auth.dart';
import 'package:slaap/middlewares/onboarding.dart';
import 'package:slaap/pages/chat.dart';
import 'package:slaap/pages/home.dart';
import 'package:slaap/pages/onboarding.dart';
import 'package:slaap/pages/settings.dart';
import 'package:slaap/pages/signin.dart';
import 'package:slaap/pages/start.dart';
import 'package:slaap/providers/auth.dart' as providers_auth;
import 'package:slaap/providers/onboarding.dart';
import 'package:slaap/utils/enum_routes.dart';

const routes = Routes(routes: Route.values);

final routerProvider = Provider((ref) {
  final onboardingState = ref.watch(OnBoardingProvider.provider);
  final authState =
      ref.watch(providers_auth.AuthProvider.authStateProvider.select(
    (value) {
      // ignore auth state changes when in onboarding screens
      if (onboardingState.valueOrNull == false) {
        return const AsyncLoading<User?>();
      }
      return value;
    },
  ));

  return GoRouter(
    routes: [
      // authenticated routes
      ShellRoute(
        routes: [
          // main tabs routes
          StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: routes.$path(Route.home),
                    builder: (context, state) {
                      return const HomePage();
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: routes.$path(Route.start),
                    builder: (context, state) {
                      return const StartPage();
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: routes.$path(Route.settings),
                    builder: (context, state) {
                      return const SettingsPage();
                    },
                  )
                ],
              )
            ],
            builder: (context, state, navigationShell) {
              return TabsLayout(navigationShell: navigationShell);
            },
          ),

          // chat routes
          GoRoute(
            path: routes.$path(Route.chat),
            builder: (context, state) {
              return ChatPage(
                id: state.pathParameters["id"]!,
              );
            },
          ),
        ],
        builder: (context, state, child) {
          return OnboardingMiddleware(
            child: AuthMiddleware(
              child: AccountMiddleware(child: child),
            ),
          );
        },
      ),

      // unauthenticated routes
      GoRoute(
        path: routes.$path(Route.signin),
        builder: (context, state) {
          return const OnboardingMiddleware(
            child: SigninPage(),
          );
        },
      ),
      GoRoute(
        path: routes.$path(Route.onboarding),
        builder: (context, state) {
          return const OnboardingPage();
        },
      ),
    ],
    redirect: (context, state) {
      final route = routes.$fromPath(state.fullPath);
      // redirect home for unknown routes
      if (route == null) return routes.home();

      // onboarding guard
      if (onboardingState.valueOrNull == false &&
          route.guard != RouteGuard.onboarding) {
        return routes.onboarding();
      }

      // auth guard
      return switch (route.guard) {
        RouteGuard.auth => switch (authState) {
            AsyncData(:final value) => value != null ? null : routes.signin(),
            AsyncError() => routes.signin(),
            _ => null,
          },
        RouteGuard.guest => switch (authState) {
            AsyncData(:final value) => value != null ? routes.home() : null,
            _ => null,
          },
        RouteGuard.authOrGuest => null,
        RouteGuard.onboarding => null,
      };
    },
  );
});

class Routes extends EnumRoutes<Route> {
  const Routes({required super.routes});

  String home() => $destination(Route.home);
  String start() => $destination(Route.start);
  String settings() => $destination(Route.settings);
  String chat(String id) => $destination(
        Route.chat,
        params: {"id": id},
      );
  String signin() => $destination(Route.signin);
  String onboarding() => $destination(Route.onboarding);
}

enum Route implements EnumPath {
  home(path: "/"),
  start(path: "/start"),
  settings(path: "/settings"),
  chat(path: "/chat/:id"),
  signin(path: "/signin", guard: RouteGuard.guest),
  onboarding(path: "/onboarding", guard: RouteGuard.onboarding);

  @override
  final String path;
  final RouteGuard guard;

  const Route({required this.path, this.guard = RouteGuard.auth});
}

enum RouteGuard {
  onboarding,
  auth,
  guest,
  authOrGuest,
}
