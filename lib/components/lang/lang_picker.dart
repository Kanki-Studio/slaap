import 'package:flutter/material.dart';
import 'package:slaap/models/lang.dart';

class LangPicker extends StatelessWidget {
  final String title;
  final void Function(SupportedLang lang) onSelect;
  final String? selected;

  const LangPicker({
    super.key,
    required this.title,
    required this.onSelect,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: SupportedLang.values.length,
              itemBuilder: (context, index) {
                final lang = SupportedLang.values.elementAt(index);

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onSelect(lang);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lang.value == selected
                            ? "${lang.displayText} (selected)"
                            : lang.displayText),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Colors.grey.shade400,
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
