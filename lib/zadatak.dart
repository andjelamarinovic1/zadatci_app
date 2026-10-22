class Zadatak {
  final int id;
  final String naslov;
  final bool zavrsen;

  const Zadatak({required this.id, required this.naslov, this.zavrsen = false});

  factory Zadatak.fromJson(Map<String, dynamic> json) => Zadatak(
        id: json['id'] as int,
        naslov: json['naslov'] as String,
        zavrsen: json['zavrsen'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'naslov': naslov,
        'zavrsen': zavrsen,
      };

  Zadatak kopiraj({String? naslov, bool? zavrsen}) => Zadatak(
        id: id,
        naslov: naslov ?? this.naslov,
        zavrsen: zavrsen ?? this.zavrsen,
      );
}