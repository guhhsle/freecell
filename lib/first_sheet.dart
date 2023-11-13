import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/functions/other.dart';
import 'package:freecell/icons.dart';

class SheetFirst extends StatelessWidget {
  const SheetFirst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Wrap(
          children: [
            const ListTile(title: Text(':0')),
            ListTile(
              leading: const Icon(SuitIcons.heart),
              title: const Text('Classic theme'),
              onTap: () {
                setPref('theme', 'greenTheme');
                setPref('iconsPref', 'ClassicIcons');
                setPref('cardBack', 'White');
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(ChessIcons.knight),
              selected: pf['theme'] == 'whiteTheme',
              title: const Text('Chess theme'),
              onTap: () {
                setPref('theme', 'whiteTheme');
                setPref('iconsPref', 'ChessIcons');
                setPref('cardBack', 'White');
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.fiber_manual_record_outlined),
              title: const Text('Dark theme'),
              selected: pf['theme'] == 'darkTheme',
              onTap: () {
                setPref('theme', 'darkTheme');
                setPref('iconsPref', 'CircleIcons');
                setPref('cardBack', 'Transparent');
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
