import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mundomagico_wiki/widgets/CharacterTile.dart';
import '../providers/characters_provider.dart';
import '../providers/color_provider.dart';
import '../theme/MagicPatternBackground.dart';
import '../widgets/BottomNavigationBar.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharactersProvider>();

    return MagicPatternBackground(
      accent: context.watch<ColorProvider>().color,
      child: Scaffold(
        appBar: AppBar(title: const Text("Characters")),
        bottomNavigationBar: const Bottomnavigationbar(currentIndex: 2),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Nombre...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: provider.searchQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<CharactersProvider>().clearSearch();
                          },
                        ),
                ),
                onChanged: context.read<CharactersProvider>().search,
              ),
            ),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(CharactersProvider provider) {
    switch (provider.status) {
      case CharactersStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case CharactersStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading characters: ${provider.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: context.read<CharactersProvider>().loadCharacters,
                  child: const Text("Reintentar"),
                ),
              ],
            ),
          ),
        );

      case CharactersStatus.ready:
        final characters = provider.characters;

        if (characters.isEmpty) {
          return const Center(child: Text("No characters found"));
        }

        return RefreshIndicator(
          onRefresh: context.read<CharactersProvider>().loadCharacters,
          child: ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterTile(
                key: ValueKey(character.name),
                character: character,
              );
            },
          ),
        );
    }
  }
}
