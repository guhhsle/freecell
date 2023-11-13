import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/functions/other.dart';
import '../../data.dart';

class PageAbout extends StatelessWidget {
  final Map<String, String> infoMap = {
    'Highscore': pf['highscore'].toString() == '[999, 999, 999, 999]'
        ? 'None'
        : pf['highscore'].toString().replaceAll('999', ' '),
    'Quickest': pf['timeboard'].toString() == '[999, 999, 999, 999]'
        ? 'None'
        : pf['timeboard'].toString().replaceAll('999', ' '),
    'Wins': pf['wins'].toString(),
    'Version': '1.4.0',
    '. . .': 'Marko',
    'Sound effects obtained from https://www.zapsplat.com': '',
  };
  final List<IconData> icons = [
    Icons.analytics_rounded,
    Icons.timelapse_rounded,
    Icons.tag_rounded,
    Icons.numbers_rounded,
    Icons.moped_rounded,
    Icons.graphic_eq_rounded,
  ];

  PageAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hintCount = 0;

    return Scaffold(
      floatingActionButton: (pf['easterEggs'] as List).isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                tooltip: 'Lol',
                child: const Icon(Icons.picture_in_picture_alt_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          color: Colors.transparent,
                          child: DraggableScrollableSheet(
                            initialChildSize: 0.4,
                            minChildSize: 0.2,
                            maxChildSize: 0.75,
                            builder: (_, controller) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text('${pf['easterEggs'].length} / ${art.length}',
                                          style: Theme.of(context).textTheme.bodyLarge),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        controller: controller,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: pf['easterEggs'].length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: Text(pf['easterEggs'][index],
                                                    style: Theme.of(context).textTheme.bodyLarge),
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return ClipRRect(
                                                        borderRadius: const BorderRadius.vertical(
                                                          top: Radius.circular(20),
                                                        ),
                                                        child: Image.network(
                                                          art[pf['easterEggs'][index]]!,
                                                          cacheWidth: 1920,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null) {
                                                              return child;
                                                            }
                                                            return Center(
                                                              child: CircularProgressIndicator(
                                                                value: loadingProgress.expectedTotalBytes != null
                                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                                        loadingProgress.expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              const Divider(
                                                thickness: 1.2,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(
          'Info',
        ),
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
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: infoMap.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        hintCount++;
                        if (hintCount % 20 == 0) {
                          easterEgg = true;
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Icon(
                              Icons.image_rounded,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Theme.of(context).primaryColor,
                          ));
                        }
                      },
                      leading: Icon(icons[index]),
                      title: Text(infoMap.keys.elementAt(index)),
                      trailing: Text(infoMap.values.elementAt(index)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
