import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/widgets/CharacterTile.dart';

import '../ data/characters_repository.dart';
import '../models/character.dart';
import '../widgets/BottomNavigationBar.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  String _searchQuery = "";
  late Future<List<Character>> _charactersFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _charactersFuture = const CharactersRepository().loadCharacters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Characters")),
      bottomNavigationBar: Bottomnavigationbar(currentIndex: 2),
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Search: "),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Nombre...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value.toLowerCase());
                  },
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = "";
                      _searchController.clear();
                    });
                  },
                ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading characters: ${snapshot.error}',
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final characters = snapshot.data!.where((character) {
                  return character.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (characters.isEmpty) {
                  return const Center(child: Text("No characters found"));
                }

                return ListView.builder(
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    return CharacterTile(character: character);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
