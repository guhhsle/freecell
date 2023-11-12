import 'package:flutter/material.dart';
import 'package:freecell/functions/deck.dart';

import 'card.dart';
import '../data.dart';
import 'item_card.dart';

class Done extends StatelessWidget {
  final int index;
  const Done({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Karta>>(
      valueListenable: deck[9],
      builder: (context, snap, child) {
        return SizedBox(
          key: keys[index],
          height: p ? w / 5 : h / 5.5,
          width: p ? w / 8 : h / 8,
          child: DragTarget(
            onWillAccept: (data) {
              return (data as List<Karta>).length == 1 &&
                  (data[0].sign == snap[index].sign) &&
                  (data[0].num == snap[index].num + 1);
            },
            onAccept: (data) {
              List<Karta> list = data as List<Karta>;
              deck[9].value[index] = list[0];
              addCount();
              refreshCol(deck[9], [], true);
            },
            builder: (context, col1, col2) {
              if (snap[index].num != 0) {
                snap[index].highlight = true;
                return ItemCard(karta: snap[index], pg: false, pd: false);
              } else {
                return Card(
                  key: snap[index].key,
                  shadowColor: Colors.transparent,
                  margin: const EdgeInsets.all(1.5),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: p ? w / 140 : h / 140,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                      child: Icon(
                    icons[pf['iconsPref']]![index],
                    color: index > 1 ? Colors.blueGrey.shade300 : Colors.red.shade300,
                  )),
                );
              }
            },
          ),
        );
      },
    );
  }
}
