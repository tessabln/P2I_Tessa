import 'package:flutter/material.dart';
import 'package:flutter_app/views/admin/accountA_view.dart';
import 'package:flutter_app/views/user/accountU_view.dart';
import 'package:flutter_app/views/admin/admin_view.dart';
import 'package:flutter_app/views/leaderboard_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminSwitch extends StatefulWidget {
  const AdminSwitch({Key? key});

  @override
  State<AdminSwitch> createState() => _AdminSwitchState();
}

class _AdminSwitchState extends State<AdminSwitch> {
  // Index to keep track of the selected view
  int _selectedIndex = 0;

  // List of views to be displayed
  final List<Widget> _views = [
    // Admin view for managing settings
    AdminView(
      onTap: () {},
    ),
    // View for displaying leaderboard
    LeaderboardView(),
    // View for managing user account
    AccountViewA(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.background,
            tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            gap: 20,
            padding: EdgeInsets.all(16),
            // List of navigation tabs
            tabs: [
              GButton(
                icon: Icons.settings,
                text: 'Gestion',
                iconColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.primary,
              ),
              GButton(
                icon: Icons.leaderboard,
                text: 'Classement',
                iconColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.primary,
              ),
              GButton(
                icon: Icons.account_circle_rounded,
                text: 'Compte',
                iconColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.primary,
              ),
            ],
            // Index of the selected tab
            selectedIndex: _selectedIndex,
            // Callback function for tab change
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
