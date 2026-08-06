import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/models/character.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // TODO: Navigate to character details screen
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