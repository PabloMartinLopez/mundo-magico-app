import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mundomagico_wiki/models/character.dart';

class CharactersRepository {
  const CharactersRepository();

  Future<List<Character>> loadCharacters() async {
    final raw = await rootBundle.loadString('assets/data/characters.json');
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}