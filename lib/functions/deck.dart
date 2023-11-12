import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/animation.dart';
import 'package:freecell/widgets/card.dart';

bool gameOver = false;

bool isEmpty() {
  bool kings = true;
  for (var i = 0; i < 4; i++) {
    if (deck[9].value[i].num != 13) {
      kings = false;
    }
  }
  if (kings && !gameOver) {
    List<int> scores = [];
    scores.add(count.value);
    for (var i = 0; i < 4; i++) {
      scores.add(int.tryParse(pf['highscore'][i]) ?? 0);
    }
    scores.sort();
    scores.removeLast();
    for (var i = 0; i < 4; i++) {
      pf['highscore'][i] = scores[i].toString();
    }
    prefs.setStringList('highscore', pf['highscore']);

    DateTime timer = DateTime.now().subtract(Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second));
    int clock = timer.hour * 360 + timer.minute * 60 + timer.second;
    scores.clear();
    scores.add(clock);
    for (var i = 0; i < 4; i++) {
      scores.add(int.tryParse(pf['timeboard'][i]) ?? 0);
    }
    scores.sort();
    scores.removeLast();
    for (var i = 0; i < 4; i++) {
      pf['timeboard'][i] = scores[i].toString();
    }
    prefs.setStringList('timeboard', pf['timeboard']);
    gameOver = true;
  }
  return kings;
}

void refreshCol(ValueNotifier<List<Karta>> col, List<Karta> arr, bool add) {
  if (pf['haptic'] && !dealing) {
    for (var i = 0; i < 12; i++) {
      HapticFeedback.heavyImpact();
    }
  }
  if (add) {
    for (var i = 0; i < arr.length; i++) {
      List<Karta> l = col.value.toList();
      l.add(arr[i]);
      col.value = l;
    }
  } else {
    for (var i = 0; i < arr.length; i++) {
      List<Karta> l = col.value.toList();
      l.removeLast();
      col.value = l;
    }
  }
}

double colHeight(List col) {
  return ((col.length - 1) * ((p ? (w / 13) : h / 15)) + (p ? (w / 5) : h / 5.5)).toDouble();
}

void restart() {
  count.value = 0;
  for (var i = 0; i < allDecks[count.value].length; i++) {
    deck[i].value = allDecks[count.value][i].value;
  }
  dt = DateTime.now();
  backup();
}

void undo() {
  if (count.value != 0) {
    count.value--;
    for (var i = 0; i < allDecks[count.value].length; i++) {
      deck[i].value = allDecks[count.value][i].value.toList();
    }
    backup();
  }
}

void addCount() {
  count.value++;
  endScreen.value = isEmpty();
  backup();
  deckToPref();
}

bool dealing = false;

Future shuffleCards() async {
  shuffling.value = true;
  dealing = true;
  endScreen.value = false;
  count.value = 0;
  gameOver = false;
  allDecks.clear();
  allCards.clear();
  List<Karta> ls = [], ld = [];
  for (var i = 0; i < 4; i++) {
    ls.add(Karta(num: 0, sign: 0, highlight: true, key: GlobalKey()));
    ld.add(Karta(num: 0, sign: i, highlight: true, key: GlobalKey()));
  }
  deck[8].value = ls;
  deck[9].value = ld;
  for (var i = 0; i < 8; i++) {
    deck[i].value = [];
  }

  dt = DateTime.now();
  for (var n = 13; n > 0; n--) {
    for (var s = 0; s < 4; s++) {
      allCards.add(Karta(num: n, sign: s, highlight: true, key: GlobalKey()));
    }
  }
  allCards.shuffle();
  if (pf['firstBoot']) {
    for (int i = 0; i < allCards.length; i++) {
      deck[i % 8].value.add(allCards[i]);
    }
  } else {
    int i = 0;
    duration = const Duration(milliseconds: 256);
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 24));
      if (i % 4 == 0 && pf['haptic']) HapticFeedback.selectionClick();
      animateShuffle(allCards[i], deck[(((i ~/ 8) % 2) * 7 - i % 8).abs()]);
      i++;
      return i < allCards.length;
    });
  }
  count.value = 0;
  await Future.delayed(const Duration(milliseconds: 512));
  dt = DateTime.now();
  duration = Duration(milliseconds: pf['durationPref']);
  pf['firstBoot'] = false;
  backup();
  deckToPref();
  shuffling.value = false;
  dealing = false;
}

int freeSpace() {
  int fs = 1;
  for (var i = 0; i < 4; i++) {
    if (deck[8].value[i].num == 0) {
      fs++;
    }
  }
  for (var i = 0; i < 8; i++) {
    if (deck[i].value.isEmpty) {
      fs *= 2;
    }
  }
  return fs;
}

void backup() {
  List<ValueNotifier<List<Karta>>> deck2 = [];
  for (var i = 0; i < 10; i++) {
    deck2.add(ValueNotifier([]));
  }
  for (var i = 0; i < 10; i++) {
    for (var q = 0; q < deck[i].value.length; q++) {
      deck2[i].value.add(deck[i].value.toList()[q]);
    }
  }
  allDecks.insert(count.value, deck2.toList());
}

void deckToPref() {
  for (var col = 0; col < 10; col++) {
    List<String> allCol = [];
    for (var move = 0; move < allDecks.length; move++) {
      allCol.add('');
      if (allDecks[move].length <= col) {
        break;
      }
      for (var i = 0; i < allDecks[move][col].value.length; i++) {
        Karta karta = allDecks[move][col].value[i];
        if (karta.num < 10) {
          allCol[move] += ('0${karta.num}${karta.sign}');
        } else {
          allCol[move] += ('${karta.num}${karta.sign}');
        }
      }
    }
    // print('COLUMN $col ${allCol[0].length/3}');
    prefs.setStringList('col$col', allCol);
  }

  prefs.setInt('count', count.value);
  DateTime timer = DateTime.now().subtract(Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second));
  prefs.setInt('time', timer.hour + timer.minute * 60 + timer.second);
}

void deckFromPref() {
  if (prefs.getStringList('col0') != null && prefs.getInt('count') != null && prefs.getInt('count')! >= 0) {
    count.value = prefs.getInt('count') ?? 0;
    for (var col = 0; col < 10; col++) {
      if (prefs.getStringList('col$col') != null) {
        List<String> column = prefs.getStringList('col$col')!;
        // print('COLUMN $col ${column[0].length/3}');
        for (var move = 0; move < column.length; move++) {
          allDecks.add([]);
          allDecks[move].add(ValueNotifier([]));
          for (var i = 0; i < column[move].length / 3; i++) {
            allDecks[move][col].value.add(
                  Karta(
                    num: int.parse(column[move][i * 3]) * 10 + int.parse(column[move][(i * 3) + 1]),
                    sign: int.parse(column[move][(i * 3) + 2]),
                    key: GlobalKey(),
                    highlight: false,
                  ),
                );
          }
        }
      }
    }
    deck = allDecks[count.value].toList();
    dt = DateTime.now().subtract(Duration(seconds: prefs.getInt('time') ?? 0));
    backup();
  }
}
