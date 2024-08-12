import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const SettingsItem({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class SettingsItemGroup extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<SettingsItem> children;

  const SettingsItemGroup({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final (ntitle, nsubtitle) = (title, subtitle);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ntitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              ntitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (nsubtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              nsubtitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(20),
              borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: children.length,
              itemBuilder: (context, index) => children[index],
              separatorBuilder: (context, index) {
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Colors.black.withAlpha(30),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
