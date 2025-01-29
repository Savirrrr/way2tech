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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigation logic based on index
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/upload');
          break;
        case 2:
          context.go('/tabswitch');
          break;
        case 3:
          context.go('/account', extra: widget.email);
          break;
      }
    }
  }

  Widget _buildNavItem(
      int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Colors.black : Colors.grey,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
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