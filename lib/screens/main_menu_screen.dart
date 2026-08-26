import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/widgets/BottomNavigationBar.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/MagicPatternBackground.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MagicPatternBackground(
      accent: context.watch<ColorProvider>().color,
      child: Scaffold(
        appBar: AppBar(title: Text("Magic world")),
        bottomNavigationBar: Bottomnavigationbar(currentIndex: 1),
        body: ListView(
          children: [
            ListTile(
              title: Text("Characters"),
              onTap: () => Navigator.pushNamed(context, '/characters'),
            ),
            ListTile(
              title: Text("Opciones"),
              onTap: () => Navigator.pushNamed(context, '/options'),
            )
          ],
        ),
      ),
    );
  }
}
