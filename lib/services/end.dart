import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/functions/deck.dart';
import '../data.dart';
import '../functions/other.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({Key? key}) : super(key: key);

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  Future playSound() async {
    Random random = Random();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      artInt.value = random.nextInt(art.length);
    });

    List<String> soundNames = [
      'assets/winSounds/001.mp3',
      'assets/winSounds/002.mp3',
      'assets/winSounds/003.mp3',
      'assets/winSounds/004.mp3',
      'assets/winSounds/005.mp3',
      'assets/winSounds/006.mp3',
    ];
    int winInt = random.nextInt(soundNames.length);
    if (pf['soundPref']) {
      int soundId = await rootBundle.load(soundNames[winInt]).then((ByteData soundData) {
        return pool.load(soundData);
      });
      await pool.play(soundId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: playSound(),
      builder: (context, snap) {
        return Center(
          child: easterEgg
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Center(
                    child: ValueListenableBuilder<int>(
                        valueListenable: artInt,
                        builder: (context, data, child) {
                          return InteractiveViewer(
                            clipBehavior: Clip.none,
                            child: Image.network(
                              art.values.elementAt(data),
                              cacheWidth: 1920,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    children: [
                      Card(
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              '${pf['highscore'] as List} moves'.replaceAll('999', ' '),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              '${pf['timeboard'] as List} seconds'.replaceAll('999', ' '),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Theme.of(context).colorScheme.background,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () {
                            setState(() {
                              prefs.setInt('count', -1);
                              pf['coins'] += 20;
                              prefs.setInt('coins', pf['coins']);
                            });
                            setPref('wins', ++pf['wins']);
                            shuffleCards();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 100,
                            child: Center(
                              child: Text(
                                'Collect 20c',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
