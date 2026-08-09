import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/providers/characters_provider.dart';
import 'package:mundomagico_wiki/providers/color_provider.dart';
import 'package:mundomagico_wiki/screens/character_detail_screen.dart';
import 'package:mundomagico_wiki/screens/characters_menu_screen.dart';
import 'package:mundomagico_wiki/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CharactersProvider()..loadCharacters(),
        ),
        ChangeNotifierProvider(
          create: (_) => ColorProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic World',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/characters': (context) => const CharacterListScreen(),
        '/character-detail': (context) => const CharacterDetailScreen(),
      },
    );
  }
}
