import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/models/character.dart';
import 'package:mundomagico_wiki/providers/character_provider.dart';
import 'package:mundomagico_wiki/providers/color_provider.dart';
import 'package:provider/provider.dart';

import '../screens/character_detail_screen.dart';
import '../theme/MagicPatternBackground.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        CharacterProvider(character);
        context.read<ColorProvider>().changeColor(MagicAccents.of(character.house));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => CharacterProvider(character),
              child: const CharacterDetailScreen(),
            ),
          ),
        );
      },
      title: Text(character.name),
      subtitle: Text(character.house),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: ClipOval(
          child: Image.network(
            character.image,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.person),
            ),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}