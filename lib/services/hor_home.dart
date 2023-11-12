import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/animation.dart';
import 'package:freecell/functions/card.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/widgets/page_custom.dart';
import 'package:intl/intl.dart';

class VerticalHome extends StatelessWidget {
  const VerticalHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: count,
      builder: (context, data, child) {
        return SizedBox(
          width: 60,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Move $data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor(context),
                ),
              ),
              pf['timer']
                  ? StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Text(
                          DateFormat('mm : ss')
                              .format(DateTime.now().subtract(Duration(minutes: dt.minute, seconds: dt.second))),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor(context),
                          ),
                        );
                      },
                    )
                  : Container(),
              IconButton(
                  tooltip: 'Menu',
                  icon: Icon(
                    Icons.menu,
                    color: textColor(context),
                  ),
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
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    tooltip: 'New',
                    //key: newGameKey,
                    icon: Icon(
                      Icons.add,
                      color: textColor(context),
                    ),
                    onPressed: () {
                      shuffleCards();
                    },
                  ),
                ),
              ),
              data > 0
                  ? IconButton(
                      tooltip: 'Restart',
                      icon: Icon(
                        Icons.settings_backup_restore_rounded,
                        color: textColor(context),
                      ),
                      onPressed: () {
                        restart();
                      },
                    )
                  : Container(),
              data > 0
                  ? IconButton(
                      tooltip: 'Undo',
                      icon: Icon(
                        Icons.undo_rounded,
                        color: textColor(context),
                      ),
                      onPressed: () {
                        undo();
                      },
                    )
                  : Container(
                      height: 48,
                    ),
            ],
          ),
        );
      },
    );
  }
}
