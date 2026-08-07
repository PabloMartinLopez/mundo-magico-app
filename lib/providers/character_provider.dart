// lib/providers/character_provider.dart
import 'package:flutter/foundation.dart';
import 'package:mundomagico_wiki/models/character.dart';

class CharacterProvider extends ChangeNotifier {
  Character _character;

  CharacterProvider(this._character);

  Character get character => _character;

}