import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/providers/characters_provider.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
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
