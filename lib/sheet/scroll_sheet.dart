import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets/custom_card.dart';

class SheetScrollModel extends StatefulWidget {
  final Map<Map<IconData, String>, Map<String, void Function(BuildContext)>> map;
  const SheetScrollModel({super.key, required this.map});

  @override
  SheetScrollModelState createState() => SheetScrollModelState();
}

class SheetScrollModelState extends State<SheetScrollModel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.75,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    CustomCard(
                      title: widget.map.keys.first.values.first,
                      onTap: () {
                        widget.map.values.first.values.first(context);
                      },
                      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Icon(
                        widget.map.keys.first.keys.first,
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: controller,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: controller,
                          itemCount: widget.map.length - 1,
                          itemBuilder: (context, index) {
                            int i = index + 1;
                            String tail = widget.map.values.toList()[i].keys.first;
                            return ListTile(
                              textColor: Theme.of(context).colorScheme.primary,
                              iconColor: Theme.of(context).colorScheme.primary,
                              leading: Icon(widget.map.keys.toList()[i].keys.first),
                              title: Text(widget.map.keys.toList()[i].values.first),
                              trailing: Text(
                                tail.startsWith('pf//') ? '${pf[tail.replaceAll('pf//', '')]}' : tail,
                              ),
                              onTap: () {
                                widget.map.values.toList()[i].values.first(context);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
