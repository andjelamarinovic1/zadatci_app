// ignore_for_file: avoid_print
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
}