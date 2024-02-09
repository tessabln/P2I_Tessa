// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_app/views/account_view.dart';
import 'package:flutter_app/views/user/home_view.dart';
import 'package:flutter_app/views/leaderboard_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeSwitch extends StatefulWidget {
  const HomeSwitch({Key? key});

  @override
  State<HomeSwitch> createState() => _HomeSwitchState();
}

class _HomeSwitchState extends State<HomeSwitch> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    HomeView(),
    LeaderboardView(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.background,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            gap: 20,
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Accueil',
              ),
              GButton(
                icon: Icons.leaderboard,
                text: 'Classement',
              ),
              GButton(
                icon: Icons.account_circle_rounded,
                text: 'Compte',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
