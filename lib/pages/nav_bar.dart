import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatefulWidget {
  final String email;
  const Navbar({super.key, required this.email});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic based on index
    switch (index) {
      case 0:
        context.go('/home'); // Navigate to Home
        break;
      case 1:
        context.go('/upload'); // Navigate to Upload
        break;
      case 2:
        context.go('/tabswitch'); // Navigate to Events
        break;
      case 3:
        context.go('/account', extra: widget.email); // Pass the email to the Account page
        break;
    }
  }

  Widget _buildNavItem(
      int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        _onItemTapped(index); // Handle taps with navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : unselectedIcon,
            color: isSelected ? Colors.black : Colors.grey, // Black for selected
            size: 28.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, Icons.home_outlined, 'Home'),
            _buildNavItem(1, Icons.upload, Icons.upload_outlined, 'Upload'),
            _buildNavItem(2, Icons.event, Icons.event_outlined, 'Events'),
            _buildNavItem(3, Icons.person, Icons.person_outline, 'Account'),
          ],
        ),
      ),
    );
  }
}