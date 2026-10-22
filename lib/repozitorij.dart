import 'dart:convert';

import 'zadatak.dart';

class ZadatciException implements Exception {
  final String poruka;
  ZadatciException(this.poruka);

  @override
  String toString() => 'ZadatciException: $poruka';
}

class ZadatakRepozitorij {
  /// Koliko prvih poziva dohvata treba završiti pogreškom.
  int neuspjeha;

  /// Ako je true, poslužitelj vraća prazan popis.
  final bool prazno;

  ZadatakRepozitorij({this.neuspjeha = 0, this.prazno = false});

  static const _odgovor = '''
[
  {"id": 1, "naslov": "Instalacija okruženja", "zavrsen": true},
  {"id": 2, "naslov": "Prvi commit", "zavrsen": true},
  {"id": 3, "naslov": "Dart: Future i Stream"},
  {"id": 4, "naslov": "Prvi zaslon s popisom"}
]''';

  Future<List<Zadatak>> dohvati() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (neuspjeha > 0) {
      neuspjeha--;
      throw ZadatciException('Nema veze s poslužiteljem');
    }
    if (prazno) return const [];
    final podaci = jsonDecode(_odgovor) as List;
    return podaci
        .map((e) => Zadatak.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
