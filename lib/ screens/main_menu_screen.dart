import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Magic world"),
      ),
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
