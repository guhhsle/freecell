import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/animation.dart';
import 'package:freecell/functions/card.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/widgets/page_custom.dart';

class FloatingHome extends StatelessWidget {
  const FloatingHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: count,
      builder: (context, data, child) {
        return Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: !(isEmpty() && easterEgg)
              ? Stack(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            tooltip: 'Menu',
                            icon: Icon(Icons.menu, size: 24, color: textColor(context)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PageCustom(),
                                ),
                              );
                            }),
                        end() && data > 0
                            ? IconButton(
                                tooltip: 'Autosolve',
                                icon: Icon(
                                  Icons.auto_awesome,
                                  color: textColor(context),
                                  size: 24,
                                ),
                                onPressed: () {
                                  autoSolve();
                                },
                              )
                            : data > 0
                                ? IconButton(
                                    tooltip: 'Hint',
                                    icon: Icon(
                                      Icons.lightbulb_outline_rounded,
                                      color: textColor(context),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      if (!animating) {
                                        hint(context);
                                      }
                                    },
                                  )
                                : Container(),
                        Expanded(child: Container()),
                        data > 0
                            ? InkWell(
                                onLongPress: () {
                                  restart();
                                },
                                child: IconButton(
                                  icon: Icon(
                                    Icons.undo_rounded,
                                    color: textColor(context),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    undo();
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: AnimatedAlign(
                        curve: Curves.easeOutQuad,
                        duration: const Duration(milliseconds: 128),
                        alignment: data > 0 ? Alignment.centerRight : Alignment.center,
                        child: IconButton(
                          tooltip: 'New',
                          icon: Icon(
                            Icons.add,
                            color: textColor(context),
                            size: 24,
                          ),
                          onPressed: () {
                            shuffleCards();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : ValueListenableBuilder<int>(
                  valueListenable: artInt,
                  builder: (context, data, child) {
                    return InkWell(
                      onTap: () {
                        pf['coins'] += 20;
                        prefs.setInt('coins', pf['coins']);
                        prefs.setInt('count', -1);
                        if (!pf['easterEggs'].contains(art.keys.elementAt(data))) {
                          pf['easterEggs'].add(art.keys.elementAt(data));
                          prefs.setStringList('easterEggs', pf['easterEggs']);
                        }
                        setPref('wins', ++pf['wins']);
                        shuffleCards();
                      },
                      child: Center(
                        child: Text(
                          '${art.keys.elementAt(data)} >>',
                          style: TextStyle(
                            color: textColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
