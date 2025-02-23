import 'package:flutter/material.dart';
import 'package:flutter_persistent_theme/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final isDarkThemeProvider = StateProvider<bool>((ref) => false);

final themeProvider = StateProvider<ThemeData>(
  (ref) => ThemeData(
    hoverColor: Colors.transparent,
    useMaterial3: false,
    brightness: ref.watch(isDarkThemeProvider) == true
        ? Brightness.dark
        : Brightness.light,
    primaryColor:
        ref.watch(isDarkThemeProvider) ? primaryColorDark : primaryColor,
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(0),
    ),
    fontFamily: 'Open_Sans',
  ),
);

class FlutterPersistentTheme {
  FlutterPersistentTheme();

  static Future<dynamic> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }
}

class ThemeClass extends ConsumerStatefulWidget {
  const ThemeClass({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ThemeClass> createState() => _ThemeClassState();
}

class _ThemeClassState extends ConsumerState<ThemeClass> {
  bool initialized = false;
  late Box<dynamic> themeBox;

  @override
  void initState() {
    super.initState();
    initTheme();
  }

  void initTheme() async {
    try {
      themeBox = await Hive.openBox('theme');
      bool? isDarkTheme = themeBox.get('theme');

      if (isDarkTheme == null) {
        initPersistentTheme();
      } else {
        loadPersistentTheme(isDarkTheme);
      }
    } catch (e) {
      initPersistentTheme();
    }

    initialized = true;
    setState(() {});
  }

  initPersistentTheme() async {
    var box = Hive.box('theme');
    box.put('theme', false);
  }

  loadPersistentTheme(bool isDarkTheme) async {
    ref.read(isDarkThemeProvider.notifier).update((state) => isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return initialized == false ? const SizedBox() : widget.child;
  }
}

toggleTheme(bool value) async {
  final themeBox = await Hive.box('theme');
  bool? isDarkTheme = themeBox.get('theme');
  if (isDarkTheme != null) {
    themeBox.put('theme', value);
  }
}
