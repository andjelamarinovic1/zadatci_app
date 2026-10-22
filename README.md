# zadatci_app

A new Flutter project.

# Zadatci – Vježba 2

**Studentica:** Anđela Marinović
**Operacijski sustav:** Windows 11
**Flutter:** [npr. 3.47.7]
**Dart:** [npr. 3.13.5]
**Uređaj:** Chrome (web), `flutter run -d chrome`

## Opis

Aplikacija Zadatci dohvaća popis zadataka iz simuliranog repozitorija (`Future.delayed`)
i prikazuje sva stanja zaslona: učitavanje, uspjeh (popis), pogrešku s ponovnim
pokušajem i prazan popis.

## Provedene izmjene

### Model
- Dodano polje `String? opis` u model `Zadatak` (konstruktor, `fromJson`, `toJson`, `kopiraj`).
- U `bin/model_provjera.dart` opis je dodan samo trećem zadatku. Za zadatak bez opisa
  ispisuje se `null`, jer `json['opis'] as String?` vraća `null` kad polje nedostaje.

### Repozitorij
- U `bin/repozitorij_provjera.dart` dohvat je pozvan dvaput istovremeno s `Future.wait`
  i izmjeren s `Stopwatch`. Izmjereno trajanje: **[816] ms**, dakle oko 800 ms, a ne
  1600 ms, jer oba Futurea čekaju istovremeno.
- Dohvat je omotan s `.timeout(Duration(milliseconds: 300))`. Budući da dohvat traje
  800 ms, baca se `TimeoutException` i ispisuje se poruka „Isteklo vrijeme”.

### Zaslon
- Poruka pogreške zamijenjena je razumljivom rečenicom na hrvatskom umjesto teksta
  `ZadatciException`.
- Ispod popisa prikazuje se broj završenih zadataka, npr. „Završeno: 2 od 4”.
- Dodatni zadatak: `ListView` je omotan u `RefreshIndicator`, pa povlačenje prema dolje
  ponovno dohvaća podatke. Testirano u Chromeu u načinu emulacije mobilnog uređaja (DevTools).


### 1. Zašto polja modela nisu promjenjiva i što ako u JSON-u nedostaje `naslov`?
Polja su `final`, pa se objekt `Zadatak` nakon stvaranja ne može mijenjati. Time je model
predvidljiv i siguran. Kad treba promjena, metoda `kopiraj` vraća novi objekt s izmijenjenim
vrijednostima, a stari ostaje isti.

Ako u JSON-u nedostaje polje `naslov`, `json['naslov']` vraća `null`, a izraz `null as String`
baca pogrešku pri izvođenju: `type 'Null' is not a subtype of type 'String' in type cast`.
To se ne može dogoditi kod `zavrsen`, jer se ondje koristi `as bool? ?? false`, ni kod `opis`,
koji je `String?`.

### 2. Što se događa kad iznimku iz Futurea ne uhvatimo ni na jednom mjestu?
Iznimka se prenosi prema gore kroz svaki `await` koji čeka taj Future. Ako je nigdje ne
uhvati `try/catch` (ili `catchError`), postaje neuhvaćena pogreška (*Unhandled exception*).
U konzolnom Dart programu ispisuje se pogreška sa stack traceom i program se prekida.
U Flutter aplikaciji pogreška se ispiše u konzolu, a radnja ostaje nedovršena, pa korisnik
ne dobije ni podatke ni razumljivu poruku. Zato pogreške treba hvatati i prikazati ih korisniku,
kao što to radi `FutureBuilder` sa `snap.hasError`.

### 3. Zašto se Future stvara u polju, a ne u metodi `build`, i koja tri stanja mora prikazati zaslon?
Metoda `build` poziva se često: nakon svakog `setState`, promjene veličine prozora ili
promjene roditeljskog widgeta. Kad bi se Future stvarao u `build`, svaki bi poziv pokrenuo novi
dohvat. `FutureBuilder` bi tada stalno dobivao novi Future i vraćao se u stanje učitavanja,
pa bi se slao nepotreban zahtjev za zahtjevom. Zato se Future stvara jednom, u polju `_buduci`,
a novi se stvara samo namjerno, u `_ponovi()` preko `setState`.

Tri stanja koja svaki zaslon s podacima mora prikazati:
1. **Učitavanje**: kružni indikator dok podaci stižu.
2. **Pogreška**: razumljiva poruka i gumb „Pokušaj ponovno”.
3. **Podaci (uspjeh)**: popis zadataka, uz poseban slučaj **praznog popisa** s porukom „Nema zadataka”.

## Problemi
Sve radi bez pogrešaka.
