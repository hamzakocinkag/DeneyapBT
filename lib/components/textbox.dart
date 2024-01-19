import 'package:flutter/material.dart';

class Textbox extends StatelessWidget {
  final Function(String value) onChanged;
  final String hint;
  final String? initialValue;
  final TextEditingController? controller;
  const Textbox({
    super.key,
    required this.onChanged,
    required this.hint,
    this.initialValue,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
