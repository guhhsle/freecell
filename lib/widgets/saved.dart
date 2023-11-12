import 'package:flutter/material.dart';
import 'package:freecell/functions/card.dart';
import 'package:freecell/functions/deck.dart';
import '../data.dart';
import 'card.dart';

import 'item_card.dart';

class Saved extends StatelessWidget {
  final int index;

  const Saved({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Karta>>(
      valueListenable: deck[8],
      builder: (context, data, child) {
        if (data[index].num == 0) {
          return SizedBox(
            width: (p ? w / 8 : h / 8),
            height: p ? w / 5 : h / 5.5,
            child: DragTarget(
              builder: (context, col01, col02) {
                return Card(
                  key: data[index].key,
                  shadowColor: Colors.transparent,
                  margin: const EdgeInsets.all(1.5),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: p ? w / 140 : h / 140,
                      ),
                      borderRadius: BorderRadius.circular(6)),
                );
              },
              onWillAccept: (value) {
                return (value as List<Karta>).length == 1;
              },
              onAccept: (value) {
                List<Karta> list = value as List<Karta>;
                List<Karta> l = deck[8].value.toList();
                l[index] = list[0];
                deck[8].value = l;
                addCount();
                refreshCol(deck[8], [], true);
              },
            ),
          );
        } else {
          Karta karta = data[index];
          List<Karta> arr = [karta];
          karta.highlight = true;
          return Draggable(
            data: arr,
            onDragStarted: () {
              refreshCol(deck[8], [], true);
              List<Karta> l = deck[8].value.toList();
              l[index] = Karta(
                num: 0,
                sign: index,
                key: GlobalKey(),
                highlight: true,
                hint: false,
              );
              deck[8].value = l;
            },
            onDraggableCanceled: (velocity, offset) {
              List<Karta> l = deck[8].value.toList();
              l[index] = karta;
              deck[8].value = l;
            },
            feedback: ItemCard(karta: karta, pg: false, pd: false),
            child: SizedBox(
              width: p ? w / 8 : h / 8,
              child: InkWell(
                enableFeedback: false,
                onTap: () {
                  if (!animating) {
                    tap(context, deck[8], arr);
                  }
                },
                child: ItemCard(
                  karta: karta,
                  pd: false,
                  pg: false,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
