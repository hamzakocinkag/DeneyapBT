import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool state;
  const Info({
    super.key,
    required this.icon,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: state
          ? Colors.red.shade700
          : Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
