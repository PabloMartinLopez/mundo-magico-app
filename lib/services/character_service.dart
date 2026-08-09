import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class CharacterException implements Exception {
  final String message;
  const CharacterException(this.message);
  @override
  String toString() => message;
}

class CharacterService {
  static const String _baseUrl = 'https://hp-api-ten.vercel.app/api/es';

  final http.Client _client;

  CharacterService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Character>> fetchCharacters() =>
      _getList(Uri.parse('$_baseUrl/characters'));

  Future<List<Character>> fetchStudents() =>
      _getList(Uri.parse('$_baseUrl/characters/students'));

  Future<List<Character>> fetchStaff() =>
      _getList(Uri.parse('$_baseUrl/characters/staff'));

  Future<List<Character>> fetchByHouse(String house) =>
      _getList(Uri.parse('$_baseUrl/house/${house.toLowerCase()}'));

  Future<List<Character>> _getList(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw CharacterException(
          'server response: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (decoded is! List) {
        throw const CharacterException('Formato de respuesta inesperado');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Character.fromJson)
          .toList();
    } on SocketException {
      throw const CharacterException('Sin conexión a internet');
    } on FormatException {
      throw const CharacterException('La respuesta no es un JSON válido');
    }
  }

  void dispose() => _client.close();
}