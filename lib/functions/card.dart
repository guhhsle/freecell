import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/animation.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/widgets/card.dart';

bool par(Karta k1, Karta k2) {
  int sign1 = 2;
  int sign2 = 3;
  if (k1.sign >= 2) {
    sign1 = 0;
    sign2 = 1;
  }
  return (k2.num == k1.num - 1) && (k2.sign == sign1 || k2.sign == sign2);
}

ValueNotifier<List<Karta>> findList(Karta karta, ValueNotifier<List<Karta>> fromList, bool isArr) {
  bool nijeArr = !isArr;
  for (var i = 0; i < 4; i++) {
    if (karta.sign == deck[9].value[i].sign && karta.num == deck[9].value[i].num + 1 && nijeArr) {
      return deck[9];
    }
  }
  for (var i = 0; i < 8; i++) {
    if (deck[i].value.isNotEmpty && par(deck[i].value.last, karta)) {
      return (deck[i]);
    }
  }
  for (var i = 0; i < 8; i++) {
    if (deck[i].value.isEmpty) {
      return (deck[i]);
    }
  }
  for (var i = 0; i < 4; i++) {
    if (deck[8].value[i].num == 0 && nijeArr) {
      return (deck[8]);
    }
  }
  return fromList;
}

Future tap(
  BuildContext context,
  ValueNotifier<List<Karta>> fromList,
  List<Karta> fromArr,
) async {
  Karta fromKarta = fromArr.first;
  ValueNotifier<List<Karta>> toList = findList(fromKarta, fromList, fromArr.length > 1);
  Karta toKarta = toList.value.isEmpty ? Karta(num: 0, sign: 0, key: GlobalKey(), highlight: true) : toList.value.last;
  if (fromList != deck[8] || toList != deck[8]) {
    if (toList == deck[9]) {
      for (var i = 0; i < 4; i++) {
        if ((fromKarta.sign == deck[9].value[i].sign) && (fromKarta.num == deck[9].value[i].num + 1)) {
          toKarta = deck[9].value[i];
          break;
        }
      }
    } else if (toList == deck[8]) {
      for (var i = 0; i < 4; i++) {
        if (deck[8].value[i].num == 0) {
          toKarta = deck[8].value[i];
          break;
        }
      }
    }
    animate(fromArr, toKarta, fromList, toList);
  }
}

void hint(BuildContext context) {
  bool ima = false;
  for (var c = 0; c < 9; c++) {
    if (c == 8) {
      for (var i = 0; i < 4; i++) {
        if (deck[8].value[i].num != 0 && findList(deck[8].value[i], deck[8], false) != deck[8]) {
          animateHint(deck[8].value[i], deck[c]);
          //deck[8].value[i].hint = true;
          //deck[c].value = deck[c].value.toList();
          ima = true;
        }
      }
    } else {
      for (var i = 0; i < deck[c].value.length; i++) {
        List<Karta> arr = array(deck[c].value[i], deck[c].value);
        bool m = arr.length <= freeSpace();
        if ((moze(deck[c].value[i], deck[c].value)) &&
            m &&
            (findList(deck[c].value[i], deck[c], arr.length > 1) != deck[c]) &&
            (findList(deck[c].value[i], deck[c], arr.length > 1) != deck[8])) {
          animate(arr, deck[c].value.last, deck[c], deck[c]);
          i = deck[c].value.length;
          //c++;
          ima = true;
        }
      }
    }
  }
  if (!ima) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('No hints'),
      duration: Duration(seconds: 1),
    ));
  }
}

bool moze(Karta k1, List<Karta> list) {
  List<Karta> listArr = [k1];
  bool dalje = true;
  for (var i = list.indexOf(k1); i + 1 < list.length && dalje; i++) {
    if (par(list[i], list[i + 1])) {
      listArr.add(
          Karta(num: list[i + 1].num, key: list[i + 1].key, sign: list[i + 1].sign, highlight: list[i + 1].highlight));
    } else {
      dalje = false;
    }
  }
  return listArr.last.highlight;
}

List<Karta> array(Karta k1, List<Karta> list) {
  bool dalje = true;
  List<Karta> listArr = [k1];
  for (var i = list.indexOf(k1); i + 1 < list.length && dalje; i++) {
    if (par(list[i], list[i + 1])) {
      listArr.add(
          Karta(num: list[i + 1].num, sign: list[i + 1].sign, key: list[i + 1].key, highlight: list[i + 1].highlight));
    } else {
      dalje = false;
    }
  }
  return listArr;
}

bool end() {
  for (var i = 0; i < 8; i++) {
    if (i < deck.length) {
      if (!(deck[i].value.isEmpty || moze(deck[i].value[0], deck[i].value))) {
        return false;
      }
    }
  }
  return true;
}
