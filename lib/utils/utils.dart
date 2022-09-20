import 'package:antd_mobile/antd_mobile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/widgets/border_view.dart';
import 'package:intl/intl.dart';
import 'package:primer/primer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:flutter/material.dart'
    show Colors, Brightness, Card, ExpansionTile, IconButton; // TODO: remove
export 'package:flutter_vector_icons/flutter_vector_icons.dart'
    show Octicons, Ionicons;

export 'extensions.dart';

class StorageKeys {
  @deprecated
  static const account = 'account';
  @deprecated
  static const github = 'github';
  @deprecated
  static const iTheme = 'theme';

  static const accounts = 'accounts';
  static const iBrightness = 'brightness';
  static const codeTheme = 'code-theme';
  static const codeThemeDark = 'code-theme-dark';
  static const iCodeFontSize = 'code-font-size';
  static const codeFontFamily = 'code-font-family';
  static const iMarkdown = 'markdown';
  static const iDefaultAccount = 'default-account';
  static const locale = 'locale';

  static getDefaultStartTabKey(String platform) =>
      'default-start-tab-$platform';
}

class CommonStyle {
  static const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const border = BorderView();
  static const verticalGap = SizedBox(height: 18);
  static final monospace = Platform.isIOS ? 'Menlo' : 'monospace'; // FIXME:
}

Color getFontColorByBrightness(Color color) {
  var grayscale = color.red * 0.3 + color.green * 0.59 + color.blue * 0.11;
  // Fimber.d('color: $color, $grayscale');

  var showWhite = grayscale < 128;
  return showWhite ? AntTheme.white : AntTheme.text;
}

TextSpan createLinkSpan(
  BuildContext context,
  String? text,
  String url,
) {
  final theme = Provider.of<ThemeModel>(context);
  return TextSpan(
    text: text,
    style: TextStyle(
      color: theme.palette.primary,
      fontWeight: FontWeight.w600,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        theme.push(context, url);
      },
  );
}

Tuple2<String, String> parseRepositoryFullName(String fullName) {
  final ls = fullName.split('/');
  assert(ls.length == 2);
  return Tuple2(ls[0], ls[1]);
}

class GithubPalette {
  static const open = Color(0xff2cbe4e);
  static const closed = PrimerColors.red600;
  static const merged = PrimerColors.purple500;
}

// final pageSize = 5;
const PAGE_SIZE = 30;

var createWarning =
    (String text) => Text(text, style: const TextStyle(color: AntTheme.danger));
var warningSpan =
    const TextSpan(text: 'xxx', style: TextStyle(color: AntTheme.danger));

List<T> join<T>(T seperator, List<T> xs) {
  List<T> result = [];
  xs.asMap().forEach((index, x) {
    if (x == null) return;

    result.add(x);
    if (index < xs.length - 1) {
      result.add(seperator);
    }
  });

  return result;
}

List<T> joinAll<T>(T seperator, List<List<T>> xss) {
  List<T> result = [];
  xss.asMap().forEach((index, x) {
    if (x.isEmpty) return;

    result.addAll(x);
    if (index < xss.length - 1) {
      result.add(seperator);
    }
  });

  return result;
}

final numberFormat = NumberFormat();

bool isNotNullOrEmpty(String? text) {
  return text != null && text.isNotEmpty;
}

// TODO: Primer
class PrimerBranchName extends StatelessWidget {
  final String? name;

  const PrimerBranchName(this.name);

  static const branchBgColor = Color(0xffeaf5ff);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      height: 16,
      decoration: const BoxDecoration(
        color: branchBgColor,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Text(
        name!,
        style: TextStyle(
          color: theme.palette.primary,
          fontSize: 14,
          height: 1,
          fontFamily: CommonStyle.monospace,
        ),
      ),
    );
  }
}

Future<void> launchStringUrl(String? url) async {
  if (url == null) return;

  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    // TODO: fallback
  }
}

final dateFormat = DateFormat.yMMMMd();

int sortByKey<T>(T key, T a, T b) {
  if (a == key && b != key) return -1;
  if (a != key && b == key) return 1;
  return 0;
}

const TOTAL_COUNT_FALLBACK = 999; // TODO:

class ListPayload<T, K> {
  K cursor;
  bool hasMore;
  Iterable<T> items;

  ListPayload({
    required this.cursor,
    required this.hasMore,
    required this.items,
  });
}
