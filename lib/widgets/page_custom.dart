import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freecell/widgets/card.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/widgets/item_card.dart';

import 'page_about.dart';

class PageCustom extends StatefulWidget {
  const PageCustom({Key? key}) : super(key: key);

  @override
  PageCustomState createState() => PageCustomState();
}

class PageCustomState extends State<PageCustom> {
  bool showIcons = false;
  bool showThemes = false;
  final List<IconData> iconsTheme = [
    Icons.ac_unit_rounded,
    Icons.nature_outlined,
    Icons.nature_outlined,
    Icons.wb_sunny_outlined,
    Icons.spa_outlined,
    Icons.filter_drama_rounded,
    Icons.spa_outlined,
    Icons.landscape_rounded,
    Icons.light,
    Icons.star_purple500_rounded,
    Icons.anchor_rounded,
    Icons.nights_stay_outlined
  ];
  final List<IconData> tileIcons = [
    Icons.headphones_rounded,
    Icons.vibration_rounded,
    Icons.timer_rounded,
    Icons.low_priority_rounded,
    Icons.animation_rounded,
    Icons.crop_portrait_rounded,
    Icons.format_italic_rounded
  ];

  @override
  Widget build(BuildContext context) {
    final List<VoidCallback> tileFunctions = [
      () => setState(() => setPref('soundPref', !pf['soundPref'])),
      () => setState(() => setPref('haptic', !pf['haptic'])),
      () => setState(() => setPref('timer', !pf['timer'])),
      () async {
        shuffling.value = true;
        setPref('reverse', !pf['reverse']);
        await Future.delayed(const Duration(milliseconds: 64));
        shuffling.value = false;
        setState(() {});
      },
      () {},
      () {
        List l = ['Colorful', 'White', 'Transparent', 'Primary'];
        setPref('cardBack', l[(l.indexOf(pf['cardBack']) + 1) % 4]);
        setState(() {});
      },
      () {
        List l = ['Roboto', 'RobotoMono', 'JetBrainsMono', 'IBMPlexMono'];
        setPref('font', l[(l.indexOf(pf['font']) + 1) % 4]);
        setState(() {});
      },
    ];
    final List<Widget> tileTitle = [
      const Text('Sound'),
      const Text('Haptic'),
      const Text('Timer'),
      const Text('Reverse'),
      Row(
        children: [
          const Text('Animation, ms'),
          Expanded(
            child: EditableText(
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setPref('durationPref', int.tryParse(value) ?? 0);
                duration = Duration(milliseconds: pf['durationPref']);
              },
              controller: TextEditingController(text: pf['durationPref'].toString()),
              focusNode: FocusNode(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: pf['font'],
              ),
              cursorColor: Theme.of(context).primaryColor,
              backgroundCursorColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          )
        ],
      ),
      const Text('Card back'),
      const Text('Font'),
    ];
    List<String> options = ['soundPref', 'haptic', 'timer', 'reverse'];
    List<Widget?> tileTrailing = [
      for (var option in options)
        Switch(
          activeColor: Theme.of(context).primaryColor,
          inactiveThumbColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Colors.grey,
          value: pf[option],
          onChanged: (value2) => setState(() => setPref(option, value2)),
        ),
      null,
      Text(pf['cardBack']),
      Text(pf['font'])
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                child: Text(
                  '${pf['coins']}c',
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () => setState(() => setPref('coins', pf['coins'] + 50)),
              ),
            ),
          )
        ],
        title: const Text('Customise'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            height: 64,
            width: double.infinity,
          ),
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            color: Theme.of(context).colorScheme.background,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: back != null
                      ? Image(
                          image: back!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                        )
                      : Container(),
                ),
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          for (int i = 0; i < 4; i++)
                            ItemCard(
                              karta: Karta(
                                num: 1,
                                sign: i,
                                key: GlobalKey(),
                                highlight: true,
                              ),
                              pg: false,
                              pd: false,
                            ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tileTitle.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: tileTitle[i],
                          onTap: tileFunctions[i],
                          trailing: tileTrailing[i],
                          leading: Icon(tileIcons[i]),
                        );
                      },
                    ),
                    CustomCard(
                      title: Row(
                        children: [
                          Icon(
                            icons[pf['iconsPref']]![0],
                            color: Theme.of(context).colorScheme.background,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            pf['iconsPref'].replaceAll('Icons', ''),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => setState(() => showIcons = !showIcons),
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Icon(
                        showIcons ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 128),
                      alignment: Alignment.topCenter,
                      child: showIcons
                          ? ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: icons.length,
                              itemBuilder: (context, index) {
                                bool done = pf['collected'].contains(icons.keys.elementAt(index));
                                String title = icons.keys.elementAt(index).replaceAll('Icons', '');
                                return CustomCard(
                                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                  title: Row(
                                    children: [
                                      Icon(
                                        pf['iconsPref'] == icons.keys.elementAt(index)
                                            ? Icons.done_outline_rounded
                                            : done
                                                ? Icons.lock_open_outlined
                                                : Icons.lock,
                                        color: Theme.of(context).colorScheme.background,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        done ? title : '200c',
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.background,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icons.values.elementAt(index)[0],
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  onTap: () {
                                    if (!done && pf['coins'] >= 200) {
                                      setPref('coins', pf['coins'] - 200);
                                      setPref(
                                        'collected',
                                        pf['collected']..add(icons.keys.elementAt(index)),
                                      );
                                    }
                                    setPref('iconsPref', icons.keys.elementAt(index));
                                    setState(() {});
                                  },
                                );
                              },
                            )
                          : Container(),
                    ),
                    Card(
                      elevation: 6,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () => setState(() => showThemes = !showThemes),
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    iconsTheme[backgroundColors.keys.toList().indexOf(pf['theme'])],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    showThemes ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 256),
                      alignment: Alignment.topCenter,
                      child: showThemes
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 32),
                              itemCount: backgroundColors.length,
                              itemBuilder: (context, index) {
                                bool done = pf['collected'].contains(backgroundColors.keys.elementAt(index));
                                return Card(
                                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                  color: backgroundColors.values.elementAt(index),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (!done && pf['coins'] >= 150) {
                                        setPref('coins', pf['coins'] - 150);
                                        setPref(
                                          'collected',
                                          pf['collected']..add(backgroundColors.keys.elementAt(index)),
                                        );
                                      }
                                      setPref('theme', backgroundColors.keys.elementAt(index));
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                      ),
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    pf['theme'] ==
                                                            backgroundColors.keys.elementAt(
                                                              index,
                                                            )
                                                        ? Icons.done_outline_rounded
                                                        : done
                                                            ? Icons.lock_open_outlined
                                                            : Icons.lock,
                                                    color: textColors.values.elementAt(index),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    done ? '' : '150c',
                                                    style: TextStyle(
                                                      color: textColors.values.elementAt(
                                                        index,
                                                      ),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                iconsTheme[index],
                                                color: textColors.values.elementAt(index),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ),
                    Card(
                      elevation: 6,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () async {
                          if (pf['back'] == '') {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.custom, allowedExtensions: ['jpeg', 'jpg', 'png', 'gif']);
                            if (result != null) {
                              setState(() {
                                pf['back'] = result.files.single.path!;
                                prefs.setString('back', pf['back']);
                                back = FileImage(File(pf['back']));
                              });
                            }
                          } else {
                            pf['back'] = '';
                            prefs.setString('back', '');
                            back = null;
                            setState(() {});
                          }
                          shuffling.value = true;
                          shuffling.value = false;
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 50,
                            child: back != null
                                ? Image(
                                    image: back!,
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Choose image / gif'),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PageAbout()));
          },
          tooltip: 'Info',
          child: const Icon(Icons.format_textdirection_l_to_r_rounded),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget title;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final void Function() onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.child,
    required this.onTap,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: margin,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: const EdgeInsets.only(left: 22), child: title),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: child,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
