// main.dart or router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



// navbar.dart
class Navbar extends StatefulWidget {
  final String email;
  final int initialIndex;

  const Navbar({
    super.key, 
    required this.email,
    this.initialIndex = 0,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    final String path = switch (index) {
      0 => '/home',
      1 => '/upload',
      2 => '/tabswitch',
      3 => '/account',
      _ => '/home',
    };

    final String encodedEmail = Uri.encodeComponent(widget.email);
    context.go('$path?email=$encodedEmail');
  }

  Widget _buildNavItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
  ) {
    final bool isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, Icons.home_outlined),
                _buildNavItem(1, Icons.upload, Icons.upload_outlined),
                _buildNavItem(2, Icons.event, Icons.event_outlined),
                _buildNavItem(3, Icons.person, Icons.person_outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}