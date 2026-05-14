import 'package:flutter/material.dart';
import '../../../features/home/presentation/screens/home_screen.dart';
import '../../../features/bookings/presentation/screens/my_bookings_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';

/// The main shell displayed after the user logs in.
/// Hosts a bottom [NavigationBar] with three tabs:
///   0 — Home        (upcoming classes + booking)
///   1 — My Bookings (list of the current user's bookings)
///   2 — Profile     (view / edit profile + profile picture)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded),
            label: 'My Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
