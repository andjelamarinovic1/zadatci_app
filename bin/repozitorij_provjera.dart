// ignore_for_file: avoid_print
import 'dart:async';

import 'package:zadatci_app/repozitorij.dart';

Future<void> main() async {
  final repo = ZadatakRepozitorij(neuspjeha: 1);

  for (var pokusaj = 1; pokusaj <= 2; pokusaj++) {
    try {
      print('Pokušaj $pokusaj: dohvaćam...');
      final zadaci = await repo.dohvati();
      for (final z in zadaci) {
        print('- ${z.naslov} (${z.zavrsen ? 'gotovo' : 'u tijeku'})');
      }
      break;
    } on ZadatciException catch (e) {
      print('Pogreška: ${e.poruka}');
    } finally {
      print('Pokušaj $pokusaj završen');
    }
  }

  // Samostalna izmjena 1: dva dohvata istovremeno s Future.wait
  final repo2 = ZadatakRepozitorij();
  final stoperica = Stopwatch()..start();
  final rezultati = await Future.wait([repo2.dohvati(), repo2.dohvati()]);
  stoperica.stop();
  print('Future.wait: ${rezultati.length} dohvata, '
      'trajanje ${stoperica.elapsedMilliseconds} ms');

  // Samostalna izmjena 2: timeout od 300 ms
  try {
    await repo2.dohvati().timeout(const Duration(milliseconds: 300));
    print('Dohvat uspio');
  } on TimeoutException {
    print('Isteklo vrijeme');
  }
}