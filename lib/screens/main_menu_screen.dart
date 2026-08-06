import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/widgets/BottomNavigationBar.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Magic world"),
      ),
      bottomNavigationBar: Bottomnavigationbar(currentIndex: 1,),
      body: ListView(
        children: [
          ListTile(
            title: Text("Characters"),
            onTap: () => Navigator.pushNamed(context, '/characters')
          )
        ],
      ),
    );
  }
}
