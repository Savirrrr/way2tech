import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      0 => '/upload',
      1 => '/upload',
      2 => '/tabswitch',
      3 => '/account',
      _ => '/home',
    };

    final String encodedEmail = Uri.encodeComponent(widget.email);
    context.go('$path?email=$encodedEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavItem(0, Icons.home, Icons.home_outlined),
          _buildNavItem(1, Icons.upload, Icons.upload_outlined),
          _buildNavItem(2, Icons.event, Icons.event_outlined),
          _buildNavItem(3, Icons.person, Icons.person_outline),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
  ) {
    final bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Container(
        padding: const EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   color: isSelected ? Colors.white.withOpacity(0.9) : Colors.transparent,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          size: 24,
        ),
      ),
    );
  }
}
