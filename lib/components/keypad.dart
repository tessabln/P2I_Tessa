import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final TextEditingController controller;

  Keypad({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeypadButton(number: "1", controller: controller),
            SizedBox(width: 10),
            KeypadButton(number: "2", controller: controller),
            SizedBox(width: 8),
            KeypadButton(number: "3", controller: controller),
          ],
        ),
        SizedBox(height: 10), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeypadButton(number: "4", controller: controller),
            SizedBox(width: 8),
            KeypadButton(number: "5", controller: controller),
            SizedBox(width: 8),
            KeypadButton(number: "6", controller: controller),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeypadButton(number: "7", controller: controller),
            SizedBox(width: 8),
            KeypadButton(number: "8", controller: controller),
            SizedBox(width: 8),
            KeypadButton(number: "9", controller: controller),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(), 
            KeypadButton(number: "0", controller: controller),
            SizedBox(width: 8),
            KeypadBackspace(controller: controller),
          ],
        ),
      ],
    );
  }
}

class KeypadButton extends StatelessWidget {
  final String number;
  final TextEditingController controller;

  KeypadButton({required this.number, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final currentValue = controller.text;
        controller.text = currentValue + number;
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(16),
                
        ),
      ),
      child: Text(
        number,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}

class KeypadBackspace extends StatelessWidget {
  final TextEditingController controller;

  KeypadBackspace({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final currentValue = controller.text;
        if (currentValue.isNotEmpty) {
          controller.text = currentValue.substring(0, currentValue.length - 1);
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(16), 
        ),
      ),
      child: Icon(Icons.backspace, color: Theme.of(context).textTheme.bodyLarge!.color,),
    );
  }
}
