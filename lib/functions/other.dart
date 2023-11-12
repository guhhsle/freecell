import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import 'package:soundpool/soundpool.dart';

Future initPrefs() async {
  for (var i = 0; i < pf.length; i++) {
    String key = pf.keys.elementAt(i);
    if (pf[key] is String) {
      if (prefs.getString(key) == null) {
        prefs.setString(key, pf[key]);
      } else {
        pf[key] = prefs.getString(key)!;
      }
    } else if (pf[key] is int) {
      if (prefs.getInt(key) == null) {
        prefs.setInt(key, pf[key]);
      } else {
        pf[key] = prefs.getInt(key)!;
      }
    } else if (key == 'firstBoot') {
      if (prefs.getBool('firstBoot') == null) {
        prefs.setBool('firstBoot', false);
      } else {
        pf['firstBoot'] = false;
      }
    } else if (pf[key] is bool) {
      if (prefs.getBool(key) == null) {
        prefs.setBool(key, pf[key]);
      } else {
        pf[key] = prefs.getBool(key)!;
      }
    } else if (pf[key] is List<String>) {
      if (prefs.getStringList(key) == null) {
        prefs.setStringList(key, pf[key]);
      } else {
        pf[key] = prefs.getStringList(key)!;
      }
    }
  }
  pool = Soundpool.fromOptions();
  soundId = await rootBundle.load('assets/flick.mp3').then((ByteData soundData) {
    return pool.load(soundData);
  });
}

void setPref(String pString, var value) {
  pf[pString] = value;
  if (value is int) {
    prefs.setInt(pString, value);
  } else if (value is bool) {
    prefs.setBool(pString, value);
  } else if (value is String) {
    prefs.setString(pString, value);
  }
  //SystemChrome.setSystemUIOverlayStyle(
  //  SystemUiOverlayStyle(
  //    statusBarColor: darken(textColors[pf['theme']]!),
  //    systemNavigationBarColor: darken(textColors[pf['theme']]!),
  //  ),
  //);
  theme.value = !theme.value;
}

Color textColor(BuildContext context) {
  if (backgroundColors.keys.toList().indexOf(pf['theme']) > 5) {
    return Theme.of(context).primaryColor;
  } else {
    return Theme.of(context).colorScheme.background;
  }
}
