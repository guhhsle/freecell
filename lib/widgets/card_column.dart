import 'package:flutter/material.dart';
import 'package:freecell/functions/card.dart';
import 'package:freecell/functions/deck.dart';
import '../data.dart';
import 'card.dart';
import 'item_card.dart';

class CardColumn extends StatelessWidget {
  final int listIndex;
  const CardColumn({Key? key, required this.listIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: theme,
      builder: (context, themeMode, widget) {
        return ValueListenableBuilder<List<Karta>>(
          valueListenable: deck[listIndex],
          builder: (context, snap, child) {
            return SizedBox(
              key: colKeys[listIndex],
              width: p ? w / 8 : h / 8,
              height: colHeight(snap) < h / 3 ? h / 3 : colHeight(snap) + (p ? (w / 5) : h / 5.5),
              child: snap.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snap.length,
                      reverse: pf['reverse'],
                      itemBuilder: (context2, i) {
                        List<Karta> snapList = snap.toList();
                        Karta karta = snapList[i];
                        List<Karta> arr = array(karta, snapList);
                        karta.highlight = i == snap.length - 1;
                        return Draggable(
                          feedback: SizedBox(
                            height: colHeight(arr),
                            width: p ? w / 8 : h / 8,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              reverse: pf['reverse'],
                              scrollDirection: Axis.vertical,
                              itemCount: arr.length,
                              itemBuilder: (BuildContext context, int index2) {
                                if (arr.length <= freeSpace() && i == deck[listIndex].value.length) {
                                  arr[index2].highlight = index2 == arr.length - 1;
                                  return ItemCard(
                                    karta: arr[index2],
                                    pd: arr.length > index2 + 1 ? (par(arr[index2], arr[index2 + 1])) : false,
                                    pg: arr.length > index2 && index2 != 0
                                        ? (par(arr[index2 - 1], arr[index2]))
                                        : false,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          onDraggableCanceled: (velocity, offset) {
                            if (arr.length <= freeSpace() && i == deck[listIndex].value.length) {
                              refreshCol(deck[listIndex], arr, true);
                            }
                          },
                          onDragStarted: () {
                            if (arr.length <= freeSpace() && i == snap.length - arr.length) {
                              refreshCol(deck[listIndex], arr, false);
                            } else if (arr.length > freeSpace()) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  'Free space: ${freeSpace()}',
                                ),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          },
                          data: (arr.length <= freeSpace() && i == snap.length - arr.length) ? arr : <Karta>[],
                          child: InkWell(
                            enableFeedback: false,
                            onTap: () {
                              if (arr.length <= freeSpace() && i == snap.length - arr.length && !animating) {
                                tap(context, deck[listIndex], arr);
                              } else if (arr.length > freeSpace()) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    'Free space: ${freeSpace()}',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ));
                              }
                            },
                            child: DragTarget(
                              builder: (context, col01, col02) {
                                return ItemCard(
                                  karta: karta,
                                  pd: snap.length - 1 > i ? (par(snap[i], snap[i + 1])) : false,
                                  pg: snap.length > i && i != 0 ? (par(snap[i - 1], snap[i])) : false,
                                );
                              },
                              onWillAccept: (data) {
                                return i == snap.length - 1 &&
                                    (data as List<Karta>).isNotEmpty &&
                                    par(karta, data[0]) &&
                                    data.length <= freeSpace();
                              },
                              onAccept: (data) {
                                refreshCol(deck[listIndex], data as List<Karta>, true);
                                addCount();
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      width: w / 8 - 1,
                      child: DragTarget(
                        builder: (context, col01, col02) {
                          return Container();
                        },
                        onWillAccept: (data) {
                          return (data as List<Karta>).isNotEmpty;
                        },
                        onAccept: (data) {
                          refreshCol(deck[listIndex], data as List<Karta>, true);
                          addCount();
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
