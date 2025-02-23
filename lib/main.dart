import 'package:flutter/material.dart';
import 'package:flutter_persistent_theme/theme/colors.dart';
import 'package:flutter_persistent_theme/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterPersistentTheme.init();

  runApp(const ProviderScope(child: PersistentThemeApp()));
}

class PersistentThemeApp extends ConsumerStatefulWidget {
  const PersistentThemeApp({super.key});

  @override
  ConsumerState<PersistentThemeApp> createState() => _PersistentThemeAppState();
}

class _PersistentThemeAppState extends ConsumerState<PersistentThemeApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeClass(
      child: GetMaterialApp(
        title: 'Flutter Persistent Theme',
        theme: ref.watch(themeProvider),
        darkTheme: ref.watch(themeProvider),
        home: const FlutterPersistentThemePage(),
      ),
    );
  }
}

class FlutterPersistentThemePage extends ConsumerStatefulWidget {
  const FlutterPersistentThemePage({super.key});

  @override
  ConsumerState<FlutterPersistentThemePage> createState() =>
      _FlutterPersistentThemePageState();
}

class _FlutterPersistentThemePageState
    extends ConsumerState<FlutterPersistentThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ref.watch(isDarkThemeProvider) ? 'Dark Theme' : 'Light Theme')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            ref.watch(isDarkThemeProvider) ? primaryColorDark : primaryColor,
        onPressed: () {
          bool isDarkTheme = ref.read(isDarkThemeProvider);
          ref.watch(isDarkThemeProvider.notifier).update((state) => !state);
          toggleTheme(!isDarkTheme);
        },
        child: ref.watch(isDarkThemeProvider)
            ? const Icon(Icons.mode_night_rounded)
            : const Icon(Icons.sunny),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
