import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/theme/MagicPatternBackground.dart';
import 'package:provider/provider.dart';
import '../providers/Language_provider.dart';

import '../providers/color_provider.dart';

class OptionsLangScreen extends StatelessWidget {
  const OptionsLangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MagicPatternBackground(
      accent: context.watch<ColorProvider>().color,
      child: Scaffold(
        appBar: AppBar(title: Text("Idioma")),
        body: ListView(
          children: [
            ListTile(
              title: Text("Español"),
              onTap: () {
                context.read<LanguageProvider>().changeLanguage("es");
              },
            ),
            ListTile(
              title: Text("Inglés"),
              onTap: () {
                context.read<LanguageProvider>().changeLanguage("en");
              },
            ),
          ],
        ),
      ),
    );
  }
}
