import 'package:flutter/material.dart';
import 'forma_ekran.dart';
import 'repozitorij.dart';
import 'zadatak.dart';
void main() => runApp(const ZadatciApp());
class ZadatciApp extends StatelessWidget {
 const ZadatciApp({super.key});
 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 debugShowCheckedModeBanner: false,
 title: 'Zadatci',
 theme: ThemeData(
 colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
 useMaterial3: true,
 ),
 home: const ZadatciEkran(),
 );
 }
}
class ZadatciEkran extends StatefulWidget {
 const ZadatciEkran({super.key});
 @override
 State<ZadatciEkran> createState() => _ZadatciEkranState();
}
class _ZadatciEkranState extends State<ZadatciEkran> {
 final _repo = ZadatakRepozitorij();
 final List<Zadatak> _zadaci = [];
 late Future<void> _ucitavanje = _ucitaj();
 Future<void> _ucitaj() async {
 final podaci = await _repo.dohvati();
 _zadaci
 ..clear()
 ..addAll(podaci);
 }
 void _ponovi() {
 setState(() {
 _ucitavanje = _ucitaj();
 });
 }
 Future<void> _dodaj() async {
 final novi = await Navigator.push<Zadatak>(
 context,
 MaterialPageRoute(builder: (_) => FormaEkran(postojeci: _zadaci)),
 );
 if (!mounted || novi == null) return;
 setState(() => _zadaci.add(novi));
 ScaffoldMessenger.of(
 context,
 ).showSnackBar(SnackBar(content: Text('Dodano: ${novi.naslov}')));}
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: const Text('Zadatci')),
 floatingActionButton: FloatingActionButton(
 onPressed: _dodaj,
 tooltip: 'Novi zadatak',
 child: const Icon(Icons.add),
 ),
 body: FutureBuilder<void>(
 future: _ucitavanje,
 builder: (context, snap) {
 if (snap.connectionState != ConnectionState.done) {
 return const Center(child: CircularProgressIndicator());
 }
 if (snap.hasError) {
 return Center(
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Icon(Icons.error_outline, size: 48, color: Colors.red),
 const SizedBox(height: 8),
 Text('${snap.error}'),
 const SizedBox(height: 8),
 FilledButton(
 onPressed: _ponovi,
 child: const Text('Pokušaj ponovno'),
 ),
],
 ),
 );
 }
 if (_zadaci.isEmpty) {
 return const Center(child: Text('Nema zadataka'));
 }
 return ListView.builder(
 itemCount: _zadaci.length,
 itemBuilder: (context, i) {
 final z = _zadaci[i];
 return ListTile(
 leading: Icon(
 z.zavrsen ? Icons.check_circle : Icons.radio_button_unchecked,
 ),
 title: Text(
 z.naslov,
 style: TextStyle(
 decoration: z.zavrsen ? TextDecoration.lineThrough : null,
 ),
 ),
 );
 },
 );
 },
 ),
 );
 }
}