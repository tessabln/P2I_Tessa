import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
                  color: const Color.fromARGB(255, 72, 57, 117), 
                  width: 1,
                ),
        ),
        padding: const EdgeInsets.all(15),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        )),
      ),
    );
  }
}
