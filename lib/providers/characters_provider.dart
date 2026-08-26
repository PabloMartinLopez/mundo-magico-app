import 'package:flutter/foundation.dart';
import 'package:mundomagico_wiki/models/character.dart';
import 'package:mundomagico_wiki/services/character_service.dart';

enum CharactersStatus { loading, ready, error }

class CharactersProvider extends ChangeNotifier {
  final CharacterService _service;

  CharactersProvider({CharacterService? service, this._lang = 'en'})
      : _service = service ?? CharacterService();

  List<Character> _all = [];
  String _searchQuery = '';
  String _lang;
  CharactersStatus _status = CharactersStatus.loading;
  String? _errorMessage;

  CharactersStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<Character> get characters {
    if (_searchQuery.isEmpty) return List.unmodifiable(_all);
    return _all
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList(growable: false);
  }

  void updateLanguage(String lang) {
    if (_lang == lang) return;
    _lang = lang;
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    _status = CharactersStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _all = await _service.fetchCharacters(_lang);
      _status = CharactersStatus.ready;
    } on CharacterException catch (e) {
      _all = [];
      _errorMessage = e.message;
      _status = CharactersStatus.error;
    } catch (_) {
      _all = [];
      _errorMessage = 'Ha ocurrido un error inesperado';
      _status = CharactersStatus.error;
    }
    notifyListeners();
  }

  void search(String query) {
    final normalized = query.toLowerCase();
    if (normalized == _searchQuery) return;
    _searchQuery = normalized;
    notifyListeners();
  }

  void clearSearch() => search('');

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}