import 'package:flutter/material.dart';
import 'package:flutter_app/components/target_list.dart';

class TargetsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cibles"),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      body: TargetList(),
    );
  }
}
