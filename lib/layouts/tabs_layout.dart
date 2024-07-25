import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabsLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TabsLayout({super.key, required this.navigationShell});

  void goToTab(index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          destinations: [
            NavDestinationItem(
              icon: Icon(
                Icons.people,
                color: Colors.grey.shade700,
                size: 26,
              ),
              onTap: () => goToTab(0),
            ),
            NavDestinationItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const SizedBox(
                  width: 64,
                  height: 40,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () => goToTab(1),
            ),
            NavDestinationItem(
              icon: Icon(
                Icons.settings,
                color: Colors.grey.shade700,
                size: 26,
              ),
              onTap: () => goToTab(2),
            )
          ],
        ),
      ),
    );
  }
}

class NavDestinationItem extends StatelessWidget {
  final String? title;
  final Widget icon;
  final void Function() onTap;

  const NavDestinationItem({
    super.key,
    this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 2),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
}
