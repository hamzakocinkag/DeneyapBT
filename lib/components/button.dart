import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool state;
  final Color activeColor;
  final Function(bool value) onChanged;
  const Button({
    super.key,
    required this.label,
    required this.icon,
    required this.state,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late bool _state = widget.state;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => widget.onChanged(_state = !_state)),
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _state
              ? widget.activeColor
              : Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: Colors.white),
            const SizedBox(height: 15),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}
