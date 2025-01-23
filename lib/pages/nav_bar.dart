import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatefulWidget {
  final String email;
  final VoidCallback? onHomeTapped;

  const Navbar({super.key, required this.email, this.onHomeTapped});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index, String route) {
  setState(() {
    _selectedIndex = index;
  });
  if (route == '/account') {
    context.go(route, extra: widget.email); 
  } else {
    context.go(route); 
  }
}
  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon, String route) {
    final bool isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        isSelected ? selectedIcon : unselectedIcon,
        color: isSelected ? Colors.black : Colors.grey,
        size: 28.0,
      ),
      onPressed: () {
        if (index == 0 && widget.onHomeTapped != null) {
          widget.onHomeTapped!();
        }
        _onItemTapped(index, route);
      },
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
            _buildNavItem(0, Icons.home, Icons.home_outlined, '/home'),
            _buildNavItem(1, Icons.upload, Icons.upload_outlined, '/upload'),
            _buildNavItem(2, Icons.event, Icons.event_outlined, '/tabswitch'),
            _buildNavItem(3, Icons.person, Icons.person_outline, '/account'),
          ],
        ),
      ),
    );
  }
}