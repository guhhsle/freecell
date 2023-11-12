import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/deck.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/services/end.dart';
import 'package:freecell/services/floating_home.dart';
import 'package:freecell/services/hor_home.dart';
import 'package:freecell/sheet/first_sheet.dart';
import 'package:freecell/widgets/done.dart';
import 'package:freecell/widgets/saved.dart';
import 'package:intl/intl.dart';

import 'card_column.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    ctx = context;
    if (prefs.getStringList('col0') == null || prefs.getInt('count') == -1) {
      shuffleCards();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pf['firstBoot']) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SheetFirst();
          },
        );
      }
      try {
        for (var i = 0; i < allDecks[count.value].length; i++) {
          deck[i].value = allDecks[count.value][i].value.toList();
        }
        backup();
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (back != null) {
      precacheImage(back!, context);
    }
    p = MediaQuery.of(context).orientation == Orientation.portrait;
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        final isExitWarning = DateTime.now().difference(timeBackPressed) >= const Duration(seconds: 3);
        timeBackPressed = DateTime.now();
        return !isExitWarning;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: shuffling,
        builder: (context, data, widget) {
          return Scaffold(
            body: AbsorbPointer(
              absorbing: data,
              child: Stack(
                children: [
                  SafeArea(
                    child: Container(
                      height: p ? 80 : 0,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: count,
                                  builder: (context, data, widget) {
                                    return Text(
                                      '$data',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: textColor(context),
                                      ),
                                    );
                                  },
                                ),
                                ValueListenableBuilder<bool>(
                                  valueListenable: theme,
                                  builder: (context, value, child) {
                                    if (pf['timer']) {
                                      return StreamBuilder(
                                        stream: Stream.periodic(
                                          const Duration(seconds: 1),
                                        ),
                                        builder: (context, snapshot) {
                                          return Center(
                                            child: Text(
                                              DateFormat('mm:ss').format(
                                                DateTime.now().subtract(
                                                  Duration(
                                                    minutes: dt.minute,
                                                    seconds: dt.second,
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor(context),
                                                fontSize: 20,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        color: Colors.black,
                        width: !p ? 80 : 0,
                        height: double.infinity,
                        child: Row(
                          children: [
                            const VerticalHome(),
                            Container(
                              width: 20,
                            )
                          ],
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black,
                      height: p ? 80 : 0,
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FloatingHome()
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: AnimatedPadding(
                      curve: Curves.easeOutQuad,
                      duration: const Duration(milliseconds: 128),
                      padding:
                          EdgeInsets.only(top: toolbar && p ? 60 : 0, bottom: toolbar && p ? 60 : 0, left: !p ? 60 : 0),
                      child: Card(
                        shadowColor: Colors.transparent,
                        color: Theme.of(context).colorScheme.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.zero,
                        child: Stack(
                          children: [
                            back != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(19),
                                    child: Image(
                                      image: back!,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                    ),
                                  )
                                : Container(),
                            p
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      !pf['reverse']
                                          ? const Row(
                                              children: [
                                                Saved(index: 0),
                                                Saved(index: 1),
                                                Saved(index: 2),
                                                Saved(index: 3),
                                                Done(index: 0),
                                                Done(index: 1),
                                                Done(index: 2),
                                                Done(index: 3),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: pf['reverse'] ? 0 : 12,
                                      ),
                                      pf['reverse']
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    toolbar = !toolbar;
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                      Stack(
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable: endScreen,
                                            builder: (context, value, child) {
                                              if (isEmpty()) {
                                                return const EndScreen();
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                pf['reverse'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                            children: const [
                                              CardColumn(listIndex: 0),
                                              CardColumn(listIndex: 1),
                                              CardColumn(listIndex: 2),
                                              CardColumn(listIndex: 3),
                                              CardColumn(listIndex: 4),
                                              CardColumn(listIndex: 5),
                                              CardColumn(listIndex: 6),
                                              CardColumn(listIndex: 7),
                                            ],
                                          ),
                                        ],
                                      ),
                                      !pf['reverse']
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    toolbar = !toolbar;
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: pf['reverse'] ? 12 : 0,
                                      ),
                                      pf['reverse']
                                          ? const Row(
                                              children: [
                                                Saved(index: 0),
                                                Saved(index: 1),
                                                Saved(index: 2),
                                                Saved(index: 3),
                                                Done(index: 0),
                                                Done(index: 1),
                                                Done(index: 2),
                                                Done(index: 3),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: pf['reverse'] ? 12 : 0,
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Column(
                                        children: [
                                          Row(
                                            children: [
                                              Saved(index: 0),
                                              Saved(index: 1),
                                              Saved(index: 2),
                                              Saved(index: 3),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(children: [
                                            Done(index: 0),
                                            Done(index: 1),
                                            Done(index: 2),
                                            Done(index: 3),
                                          ])
                                        ],
                                      ),
                                      isEmpty()
                                          ? const EndScreen()
                                          : SizedBox(
                                              height: h,
                                              child: Row(
                                                crossAxisAlignment:
                                                    pf['reverse'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                children: const [
                                                  CardColumn(listIndex: 0),
                                                  CardColumn(listIndex: 1),
                                                  CardColumn(listIndex: 2),
                                                  CardColumn(listIndex: 3),
                                                  CardColumn(listIndex: 4),
                                                  CardColumn(listIndex: 5),
                                                  CardColumn(listIndex: 6),
                                                  CardColumn(listIndex: 7),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
