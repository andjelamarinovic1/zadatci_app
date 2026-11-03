import 'package:flutter/material.dart';
import 'zadatak.dart';
class FormaEkran extends StatefulWidget {
 /// Postojeći zadatci, potrebni za provjeru duplikata i dodjelu id-a.
 final List<Zadatak> postojeci;
 const FormaEkran({super.key, required this.postojeci});
 @override
 State<FormaEkran> createState() => _FormaEkranState();
}
class _FormaEkranState extends State<FormaEkran> {
 final _kljuc = GlobalKey<FormState>();
 final _naslov = TextEditingController();
 bool _zavrsen = false;
 @override
 void dispose() {
 _naslov.dispose();
 super.dispose();
 }
 String? _provjeriNaslov(String? vrijednost) {
 final tekst = vrijednost?.trim() ?? '';
 if (tekst.isEmpty) return 'Unesite naslov';
 if (tekst.length < 3) return 'Naslov mora imati najmanje 3 znaka';
 return null;
 }
void _spremi() {
 if (!_kljuc.currentState!.validate()) return;
 final noviId =
 widget.postojeci.fold<int>(
 0,
 (najveci, z) => z.id > najveci ? z.id : najveci,
 ) +
 1;
 final zadatak = Zadatak(
 id: noviId,
 naslov: _naslov.text.trim(),
 zavrsen: _zavrsen,
 );
 Navigator.pop(context, zadatak);
 }
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: const Text('Novi zadatak')),
 body: Padding(
 padding: const EdgeInsets.all(16),
 child: Form(
 key: _kljuc,
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 TextFormField(controller: _naslov,
 decoration: const InputDecoration(
 labelText: 'Naslov',
 border: OutlineInputBorder(),
 ),
 textInputAction: TextInputAction.done,
 validator: _provjeriNaslov,
 onFieldSubmitted: (_) => _spremi(),
 ),
 const SizedBox(height: 8),
 CheckboxListTile(
 title: const Text('Već završen'),
 value: _zavrsen,
 onChanged: (v) => setState(() => _zavrsen = v ?? false),
 contentPadding: EdgeInsets.zero,
 ),
 const SizedBox(height: 8),
 FilledButton(onPressed: _spremi, child: const Text('Spremi')),
 const SizedBox(height: 8),
OutlinedButton(
  onPressed: () => Navigator.pop(context),
  child: const Text('Odustani'),
),
 ],
 ),
 ),
 ),
 );
 }
}