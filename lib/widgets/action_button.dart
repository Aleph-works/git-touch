import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ActionItem {
  String? text;
  String? url;
  bool isDestructiveAction;
  void Function(BuildContext context)? onTap;
  IconData? iconData;

  ActionItem({
    required this.text,
    this.onTap,
    this.url,
    this.iconData,
    this.isDestructiveAction = false,
  });

  static List<ActionItem> getUrlActions(String? url) {
    return [
      ActionItem(
        text: 'Share',
        iconData: Octicons.rocket,
        onTap: (_) {
          Share.share(url!);
        },
      ),
      ActionItem(
        text: 'Open in Browser',
        iconData: Octicons.globe,
        onTap: (_) {
          launchStringUrl(url);
        },
      ),
    ];
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final List<ActionItem> items;
  final IconData iconData;
  final int? selected;

  const ActionButton({
    required this.title,
    required this.items,
    this.iconData = Ionicons.ellipsis_horizontal,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: () async {
        var value = await showCupertinoModalPopup<int>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(title),
              actions: items.asMap().entries.map((entry) {
                return CupertinoActionSheetAction(
                  child: Row(
                    children: [
                      Icon(entry.value.iconData),
                      const SizedBox(width: 10),
                      Text(
                        entry.value.text!,
                        style: TextStyle(
                            fontWeight: selected == entry.key
                                ? FontWeight.w500
                                : FontWeight.w400),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context, entry.key);
                  },
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            );
          },
        );

        if (value != null) {
          if (items[value].onTap != null) items[value].onTap!(context);
          if (items[value].url != null) {
            theme.push(context, items[value].url!);
          }
        }
      },
      child: Icon(iconData, size: 22),
    );
  }
}
