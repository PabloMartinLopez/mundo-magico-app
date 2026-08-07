import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  const CharacterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterProvider>().character;

    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Center(
        child: Text(
          character.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}