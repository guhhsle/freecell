// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/widgets/card.dart';
import 'package:freecell/widgets/item_card.dart';

int flyingCount = 0;
Future autoSolve() async {
  dealing = true;
  duration = const Duration(milliseconds: 256);
  shuffling.value = true;
  while (!isEmpty()) {
    for (int c = 0; c < 8; c++) {
      if (deck[c].value.isNotEmpty) {
        Karta last = deck[c].value.last;
        if (last.num == deck[9].value[last.sign].num + 1) {
          await animateSolve(deck[c], 9);
        }
      }
    }
    for (int c = 0; c < 4; c++) {
      Karta karta = deck[8].value[c];
      if (karta.num == deck[9].value[karta.sign].num + 1) {
        await animateSolve(deck[8], c);
      }
    }
  }

  duration = Duration(milliseconds: pf['durationPref']);
  shuffling.value = false;
  dealing = false;
}

Future<void> animateSolve(ValueNotifier<List<Karta>> fromList, int i) async {
  Karta last = fromList.value.last;
  if (i < 9) {
    last = deck[8].value[i];
    List<Karta> l = deck[8].value.toList();
    l[i] = Karta(num: 0, sign: 0, highlight: true, key: GlobalKey());
    deck[8].value = l;
    refreshCol(fromList, [], false);
  } else {
    refreshCol(fromList, [last], false);
  }
  final entry = OverlayEntry(
    builder: (BuildContext context) {
      return TweenAnimationBuilder(
        tween: Tween<Offset>(
          begin: (last.key.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero),
          end:
              (deck[9].value[last.sign].key.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero),
        ),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context2, Offset value, child) {
          return Positioned(
            left: value.dx,
            top: value.dy,
            child: SizedBox(
              height: colHeight([last]),
              width: p ? w / 8 : h / 8,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 1,
                shrinkWrap: true,
                reverse: pf['reverse'],
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index2) {
                  last.key = GlobalKey();
                  last.highlight = true;
                  return ItemCard(
                    karta: last,
                    pd: false,
                    pg: false,
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
  Overlay.of(ctx).insert(entry);
  await Future.delayed(const Duration(milliseconds: 64));
  unawaited(Future.delayed(duration, () {
    entry.remove();
  }));
  if (pf['haptic']) HapticFeedback.selectionClick();
  refreshCol(deck[9], [], false);
  List<Karta> l = deck[9].value.toList();
  l[last.sign].num++;
  deck[9].value = l;
  addCount();
}

Future<void> animateShuffle(Karta fromKarta, ValueNotifier<List<Karta>> toList) async {
  bool empty = toList.value.isEmpty;
  Karta toKarta;
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      final box1 = keys[fromKarta.sign].currentContext!.findRenderObject() as RenderBox;
      final pos1 = box1.localToGlobal(Offset.zero);
      final RenderBox box2;

      if (!empty) {
        toKarta = toList.value.last;
        box2 = toKarta.key.currentContext!.findRenderObject() as RenderBox;
      } else {
        box2 = colKeys[deck.indexOf(toList)].currentContext!.findRenderObject() as RenderBox;
      }

      Offset pos2 = box2.localToGlobal(
        Offset(
          0,
          pf['reverse'] && empty
              ? (h / 3 - (p ? w / 5 : h / 5.5))
              : pf['reverse']
                  ? -(p ? w / 13 : h / 15)
                  : empty
                      ? 0
                      : 32,
        ),
      );

      animating = true;
      final entry = OverlayEntry(
        builder: (BuildContext context) {
          return TweenAnimationBuilder(
            tween: Tween<Offset>(begin: pos1, end: pos2),
            duration: duration,
            curve: Curves.easeOutQuad,
            builder: (_, Offset value, child) {
              return Positioned(
                left: value.dx,
                top: value.dy,
                child: SizedBox(
                  child: ItemCard(
                    karta: fromKarta,
                    pd: false,
                    pg: false,
                  ),
                ),
              );
            },
          );
        },
      );
      Overlay.of(ctx).insert(entry);
      await Future.delayed(duration);
      entry.remove();
      flyingCount--;
      animating = false;
      refreshCol(toList, [fromKarta], true);
    },
  );
}

Future<void> animate(
  List<Karta> fromArr,
  Karta toKarta,
  ValueNotifier<List<Karta>> fromList,
  ValueNotifier<List<Karta>> toList,
) async {
  bool empty = toList.value.isEmpty;
  Karta fromKarta = fromArr.first;
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      final box1 = (pf['reverse'] ? fromArr.last : fromArr.first).key.currentContext!.findRenderObject() as RenderBox;
      final pos1 = box1.localToGlobal(Offset.zero);
      final RenderBox box2;
      if (!empty) {
        box2 = toKarta.key.currentContext!.findRenderObject() as RenderBox;
      } else {
        box2 = colKeys[deck.indexOf(toList)].currentContext!.findRenderObject() as RenderBox;
      }
      Offset pos2 = box2.localToGlobal(Offset(0, pf['reverse'] ? -(colHeight(fromArr)) : colHeight([1])));

      if (toList == deck[8] || toList == deck[9]) {
        pos2 = box2.localToGlobal(Offset.zero);
      } else if (empty && pf['reverse']) {
        pos2 = box2.localToGlobal(Offset(0, h / 3 - colHeight(fromArr)));
      } else if (empty) {
        pos2 = box2.localToGlobal(Offset.zero);
      }
      if (fromList == deck[8]) {
        List<Karta> l = deck[8].value.toList();
        l[fromList.value.indexOf(fromKarta)] = Karta(num: 0, sign: 0, highlight: true, key: GlobalKey());

        deck[8].value = l;
        refreshCol(fromList, [], false);
      } else {
        refreshCol(fromList, fromArr, false);
      }
      animating = true;
      flyingCount++;
      final entry = OverlayEntry(
        builder: (BuildContext context) {
          return TweenAnimationBuilder(
            tween: Tween<Offset>(begin: pos1, end: pos2),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context2, Offset value, child) {
              return Positioned(
                left: value.dx,
                top: value.dy,
                child: SizedBox(
                  height: colHeight(fromArr),
                  width: p ? w / 8 : h / 8,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: fromArr.length,
                    shrinkWrap: true,
                    reverse: pf['reverse'],
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index2) {
                      fromArr[index2].key = GlobalKey();
                      fromArr[index2].highlight = index2 == fromArr.length - 1;
                      return ItemCard(
                        karta: fromArr[index2],
                        pd: index2 != fromArr.length - 1,
                        pg: index2 != 0,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      );
      Overlay.of(ctx).insert(entry);
      await Future.delayed(duration);
      if (pf['soundPref']) {
        pool.play(soundId);
      }
      entry.remove();
      if (toList == deck[8] || toList == deck[9]) {
        List<Karta> l = toList.value.toList();
        l[l.indexOf(toKarta)] = fromArr.first;
        toList.value = l;
        refreshCol(toList, [], true);
      } else {
        refreshCol(toList, fromArr, true);
      }
      flyingCount--;
      if (toList != fromList) {
        addCount();
      }
      animating = false;
    },
  );
}

Future<void> animateHint(
  Karta karta,
  ValueNotifier<List<Karta>> fromList,
) async {
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      int index = fromList.value.indexOf(karta);
      final box1 = karta.key.currentContext!.findRenderObject() as RenderBox;
      final pos1 = box1.localToGlobal(Offset.zero);
      Offset pos2 = box1.localToGlobal(Offset(0, (p ? w / 10 : h / 11) * (pf['reverse'] ? -1 : 1)));

      if (fromList == deck[8]) {
        List<Karta> l = deck[8].value.toList();
        l[fromList.value.indexOf(karta)] = Karta(num: 0, sign: 0, highlight: true, key: GlobalKey());
        deck[8].value = l;
      } else {
        refreshCol(fromList, [karta], false);
      }
      animating = true;
      final entry = OverlayEntry(
        builder: (BuildContext context) {
          return TweenAnimationBuilder(
            tween: Tween<Offset>(begin: pos1, end: pos2),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context2, Offset value, child) {
              return Positioned(
                left: value.dx,
                top: value.dy,
                child: SizedBox(
                  height: colHeight([karta]),
                  width: p ? w / 8 : h / 8,
                  child: ItemCard(
                    karta: karta,
                    pd: false,
                    pg: false,
                  ),
                ),
              );
            },
          );
        },
      );
      Overlay.of(ctx).insert(entry);
      await Future.delayed(duration);
      if (pf['soundPref']) {
        pool.play(soundId);
      }
      entry.remove();
      if (fromList == deck[8]) {
        List<Karta> l = deck[8].value.toList();
        l[index] = karta;
        fromList.value = l;
      } else {
        refreshCol(fromList, [karta], true);
      }
      flyingCount--;
      animating = false;
    },
  );
}
