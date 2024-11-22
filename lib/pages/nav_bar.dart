import 'package:flutter/material.dart';
import 'package:way2techv1/pages/account.dart';
import 'package:way2techv1/pages/home.dart';
import 'package:way2techv1/pages/tabswitch.dart';
import 'package:way2techv1/pages/upload.dart';

class Navbar extends StatefulWidget {
  final String email;
  final VoidCallback? onHomeTapped;

  const Navbar({super.key, required this.email, this.onHomeTapped});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  // Keep track of the selected index
  int _selectedIndex = 0;

  void _onItemTapped(int index, Widget targetPage) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    }
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
            IconButton(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: _selectedIndex == 0 ? Colors.black : Colors.black54,
              ),
              onPressed: () {
                if (widget.onHomeTapped != null) {
                  widget.onHomeTapped!();
                }
                _onItemTapped(0, FlipPageView(email: widget.email));
              },
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 1 ? Icons.upload : Icons.upload_outlined,
                color: _selectedIndex == 1 ? Colors.black : Colors.black54,
              ),
              onPressed: () =>
                  _onItemTapped(1, UploadPage(email: widget.email)),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 2 ? Icons.event : Icons.event_outlined,
                color: _selectedIndex == 2 ? Colors.black : Colors.black54,
              ),
              onPressed: () =>
                  _onItemTapped(2, TabSwitchingPage(email: widget.email)),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                color: _selectedIndex == 3 ? Colors.black : Colors.black54,
              ),
              onPressed: () =>
                  _onItemTapped(3, AccountPage(email: widget.email)),
            ),
          ],
        ),
      ),
    );
  }
}
