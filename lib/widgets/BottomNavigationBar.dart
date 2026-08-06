import 'package:flutter/material.dart';

class Bottomnavigationbar extends StatelessWidget {
  final int currentIndex;
  const Bottomnavigationbar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Characters',
        ),
      ],
      onTap: (index) {
        // Handle navigation
      },
    );
  }
}
