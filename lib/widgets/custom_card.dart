import 'package:flutter/material.dart';

import '../data.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets margin;
  final void Function() onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.child,
    required this.onTap,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 6,
        shadowColor: Theme.of(context).colorScheme.primary,
        margin: margin,
        color: Theme.of(context).colorScheme.primary,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      title.startsWith('pf//') ? '${pf[title.replaceAll('pf//', '')]}' : title,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    child: child,
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
