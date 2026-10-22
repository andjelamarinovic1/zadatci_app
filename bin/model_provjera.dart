// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:zadatci_app/zadatak.dart';

void main() {
  const tekst = '''
[
  {"id": 1, "naslov": "Instalacija", "zavrsen": true},
  {"id": 2, "naslov": "Git"},
  {"id": 3, "naslov": "Dart", "zavrsen": false}
]''';

  final lista = (jsonDecode(tekst) as List)
      .map((e) => Zadatak.fromJson(e as Map<String, dynamic>))
      .toList();

  print('Zadataka: ${lista.length}');
  print('Drugi je zavrsen: ${lista[1].zavrsen}');
  print(jsonEncode(lista.first.toJson()));
  print(lista[1].kopiraj(zavrsen: true).zavrsen);
}