import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/MagicPatternBackground.dart';
import '../widgets/BottomNavigationBar.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MagicPatternBackground(
      accent: context.watch<ColorProvider>().color,
      child: Scaffold(
        appBar: AppBar(title: Text("Opciones")),
        bottomNavigationBar: Bottomnavigationbar(currentIndex: 3),
        body: ListView(
          children: [
            ListTile(
              title: Text("Idioma"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/options/lang');
                },
                icon: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(thickness: 1.0),
            ListTile(title: Text("Version: 1.0")),
          ],
        ),
      ),
    );
  }
}
