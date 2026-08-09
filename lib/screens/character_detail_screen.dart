import 'package:flutter/material.dart';
import 'package:mundomagico_wiki/models/character.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  const CharacterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterProvider>().character;

    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Header(character: character),
          const SizedBox(height: 16),
          _StatusChips(character: character),
          _Section(
            title: 'Datos personales',
            rows: {
              'Especie': character.species,
              'Género': character.gender,
              'Ascendencia': character.ancestry,
              'Nacimiento': character.dateOfBirth,
              'Año': character.yearOfBirth == 0
                  ? ''
                  : '${character.yearOfBirth}',
            },
          ),
          _Section(
            title: 'Biografía',
            rows: {
              'Biografía': character.biography,
              'Biografía-spoiler': character.biographyFull,
            },
          ),
          _Section(
            title: 'Apariencia',
            rows: {
              'Ojos': character.eyeColour,
              'Pelo': character.hairColour,
              'Patronus': character.patronus,
            },
          ),
          _Section(
            title: 'Varita',
            rows: {
              'Madera': character.wand.wood,
              'Núcleo': character.wand.core,
              'Longitud': character.wand.length == null
                  ? ''
                  : '${character.wand.length}"',
            },
          ),
          _Section(title: 'Reparto', rows: {'Actor': character.actor}),
          _ChipList(title: 'Otros nombres', values: character.alternateNames),
          _ChipList(title: 'Otros actores', values: character.alternateActors),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Map<String, String> rows;

  const _Section({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    // Los campos vacíos desaparecen; si no queda ninguno, la sección tampoco.
    final visible = Map.fromEntries(
      rows.entries.where((e) => e.value.trim().isNotEmpty),
    );
    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          for (final entry in visible.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChipList extends StatelessWidget {
  final String title;
  final List<String> values;

  const _ChipList({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final value in values)
                Chip(label: Text(value), visualDensity: VisualDensity.compact),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  final Character character;
  const _StatusChips({required this.character});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: Icon(
            character.alive ? Icons.favorite : Icons.close,
            size: 16,
            color: character.alive ? Colors.green : Colors.grey,
          ),
          label: Text(character.alive ? 'Vivo' : 'Fallecido'),
          visualDensity: VisualDensity.compact,
        ),
        if (character.hogwartsStudent)
          const Chip(
            avatar: Icon(Icons.school, size: 16),
            label: Text('Estudiante de Hogwarts'),
            visualDensity: VisualDensity.compact,
          ),
        if (character.hogwartsStaff)
          const Chip(
            avatar: Icon(Icons.work, size: 16),
            label: Text('Profesorado de Hogwarts'),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Character character;

  const _Header({required this.character});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 130,
            height: 180,
            child: character.image.isNotEmpty
                ? Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => const _NoImage(),
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                  )
                : const _NoImage(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                character.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                character.wizard
                    ? (character.house.isNotEmpty
                          ? character.house
                          : 'Sin casa')
                    : 'Muggle',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _houseColor(character.house),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Color _houseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return const Color(0xFF7F0909);
      case 'slytherin':
        return const Color(0xFF1A472A);
      case 'ravenclaw':
        return const Color(0xFF0E1A40);
      case 'hufflepuff':
        return const Color(0xFF946B2D);
      default:
        return const Color(0xFF5E5E5E);
    }
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_not_supported, size: 40),
    );
  }
}
