import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  deckFromPref();
  initPrefs();
  if (!kIsWeb && await File(pf['back']).exists()) {
    back = FileImage(File(pf['back']));
  }
  duration = Duration(milliseconds: pf['durationPref']);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: theme,
      builder: (context, themeMode, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Freecell',
          theme: themeData(
            tc: textColors[pf['theme']]!,
            bc: backgroundColors[pf['theme']]!,
          ),
          home: const Home(),
        );
      },
    );
  }
}
