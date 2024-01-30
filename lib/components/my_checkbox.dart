import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? checkedColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.checkedColor,
  }); 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
            width: 2.0,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: 20.0,
                color: Theme.of(context).colorScheme.inversePrimary,
              )
            : null,
      ),
    );
  }
}
