import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'card.dart';

class ItemCard extends StatelessWidget {
  final Karta karta;
  final bool pd, pg;
  const ItemCard({Key? key, required this.karta, required this.pg, required this.pd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: karta.hint ? Theme.of(context).colorScheme.primary : Colors.transparent,
      duration: Duration(
        milliseconds: karta.hint
            ? 500
            : shuffling.value
                ? 0
                : 64,
      ),
      key: karta.key,
      width: p ? w / 8 : h / 8,
      height: p
          ? (karta.highlight ? w / 5 : w / 13)
          : karta.highlight
              ? h / 5.5
              : h / 15,
      child: Container(
        margin: EdgeInsets.only(
          left: p ? w / 200 : h / 240,
          right: p ? w / 200 : h / 240,
          top: (pf['reverse'] ? pd : pg) ? 0 : 2,
          bottom: (pf['reverse'] ? pg : pd) ? 0 : 2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: p ? w / 140 : h / 140,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: (pf['reverse'] ? pg : pd) ? Radius.zero : const Radius.circular(6),
            bottomRight: (pf['reverse'] ? pg : pd) ? Radius.zero : const Radius.circular(6),
            topLeft: (pf['reverse'] ? pd : pg) ? Radius.zero : const Radius.circular(6),
            topRight: (pf['reverse'] ? pd : pg) ? Radius.zero : const Radius.circular(6),
          ),
          color: karta.sign < 2 && pf['cardBack'] == 'Colorful'
              ? Colors.red.shade200
              : pf['cardBack'] == 'Colorful'
                  ? Colors.blueGrey.shade200
                  : pf['cardBack'] == 'Primary'
                      ? textColors[pf['theme']]
                      : pf['cardBack'] == 'Transparent'
                          ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)
                          : Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: p ? w / 28 : h / 33,
                    fontWeight: FontWeight.bold,
                    fontFamily: pf['font'],
                    decoration: TextDecoration.none,
                    color: pf['cardBack'] == 'Transparent'
                        ? Theme.of(context).colorScheme.primary
                        : pf['cardBack'] == 'Primary'
                            ? backgroundColors[pf['theme']]
                            : Colors.black,
                  ),
                  child: Text(
                    karta.num == 11
                        ? 'J'
                        : karta.num == 12
                            ? 'Q'
                            : karta.num == 13
                                ? 'K'
                                : karta.num == 1
                                    ? 'A'
                                    : karta.num.toString(),
                  ),
                ),
                Icon(
                  icons[pf['iconsPref']]![karta.sign],
                  size: p ? w / 28 : h / 28,
                  color: (karta.sign == 0 || karta.sign == 1) ? Colors.red : Colors.blueGrey.shade800,
                )
              ],
            ),
            karta.highlight
                ? Expanded(
                    child: Icon(
                      icons[pf['iconsPref']]![karta.sign],
                      color: (karta.sign == 0 || karta.sign == 1) ? Colors.red : Colors.blueGrey.shade800,
                      //size: p ? w / 16 : h / 16,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
