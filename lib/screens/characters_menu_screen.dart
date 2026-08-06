import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/widgets/CharacterTile.dart';

import '../ data/characters_repository.dart';
import '../models/character.dart';
import '../widgets/BottomNavigationBar.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Characters"),
      ),
      bottomNavigationBar: Bottomnavigationbar(currentIndex: 2,),
      body: FutureBuilder<List<Character>>(
        future: const CharactersRepository().loadCharacters(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar personajes: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterTile(character: character,);
            },
          );
        },
      ),
    );
  }
}