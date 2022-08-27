import '../datasource/quran_datasource.dart';
import '../model/surah_content_model.dart';
import '../model/surah_header_model.dart';

const Map<String, String> arabicDigits = <String, String>{
  '0': '\u0660',
  '1': '\u0661',
  '2': '\u0662',
  '3': '\u0663',
  '4': '\u0664',
  '5': '\u0665',
  '6': '\u0666',
  '7': '\u0667',
  '8': '\u0668',
  '9': '\u0669',
};

QuranDatasource getDataSource() {
  return QuranDatasource();
}

///Returns Al Quran data containing list of surah and its detail
///
///Example:
///
///```dart
///getSurahList();
///```
///
/// Returns List of Surahs:
///
///```dart
///{
///surah: [
///    {
///      "id": "1",
///      "name_arabic": "الفاتحة",
///      "name_latin": "Al Fatihah",
///      "asma": "الفاتحة",
///      "ayah": 7,
///      "type": "Makkiyah",
///      "transliteration": "Al Fatihah",
///      "audio": "https://server8.mp3quran.net/afs/001.mp3"
///    },...]
/// }
///```
///
///Length of the list is the total number of surah in Al Quran.
Future<List<SurahHeaderModel>> getSurahList() {
  return getDataSource().getSurahList();
}

///Returns Al Quran data containing list of surah and its detail
///
///Example:
///
///```dart
///searchSurah('Al Fatihah');
///```
///
/// Returns List of Surahs:
///
///```dart
/// [
///    {
///      "id": "1",
///      "name_arabic": "الفاتحة",
///      "name_latin": "Al Fatihah",
///      "asma": "الفاتحة",
///      "ayah": 7,
///      "type": "Makkiyah",
///      "transliteration": "Al Fatihah",
///      "audio": "https://server8.mp3quran.net/afs/001.mp3"
///    }
/// ]
///```
///
///Length of the list is the total number of surah in Al Quran.
Future<List<SurahHeaderModel>> searchSurah(String text) async {
  var surahList = await getDataSource().getSurahList();
  var searchList = surahList
      .where((element) =>
          filterText(element.nameLatin!).contains(filterText(text)))
      .toList();
  return searchList;
}

filterText(String text) {
  return text
      .toLowerCase()
      .replaceAll(' ', '')
      .replaceAll('aa', 'a')
      .replaceAll("'", '')
      .replaceAll('uu', 'u')
      .replaceAll('jj', 'j')
      .replaceAll('to', 'tha')
      .replaceAll('tho', 'tha')
      .replaceAll('asy', 'as')
      .replaceAll('sh', 's')
      .replaceAll('thi', 'ti')
      .replaceAll('ii', 'i')
      .replaceAll('ff', 'f')
      .replaceAll('gho', 'gha')
      .replaceAll('gh', 'g')
      .replaceAll('kh', 'h')
      .replaceAll('ts', 's')
      .replaceAll('dz', 'z')
      .replaceAll('thu', 'tu')
      .replaceAll('gho', 'gha')
      .replaceAll('go', 'gha')
      .replaceAll('qq', 'q')
      .replaceAll('dd', 'd')
      .replaceAll('dh', 'd');
}

///Returns Surah Data such as surah name, aya, translation and transliteration
///
///Example:
///
///```dart
///getSurahData(surahNumber: '1', translationLang: 'english');
///```
///
/// Returns name, aya list, aya translation list and transliteration (latin):
///
///```dart
/// {
///  "id": "1",
///  "name": "الفاتحة",
///  "aya": [
///    {
///      "id": "1",
///      "text":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
///    },...
/// ]
///  "translation": [
///    {
///      "id": "1",
///      "text": "Dengan menyebut nama Allah Yang Maha Pemurah lagi Maha Penyayang."
///    },...
/// ]
///```
///
///Length of the list is the total number of surah in Al Quran.
Future<SurahContentModel> getSurahData(
    {required String surahNumber, required String translationLang}) async {
  return await getDataSource().getSurahContent(
      surahNumber: surahNumber, translationLang: translationLang);
}

///Returns Aya Data such as number, arabic text, translation, transliteration
///
///Example:
///
///```dart
///getAya(surahNumber: '1', aya: '1', translationLang: 'english');
///```
///
/// Returns number, arabic text, translation, transliteration:
///
///```dart
///
///
///    {
///      "id": "1",
///      "text":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
///      "translation": "Dengan Menyebut Nama Allah yang Maha Pengasih lagi Maha Penyayang"
///
///    }
///```
///
//
Future<Aya> getAyaData(
    {required int surahNumber,
    required int ayaNumber,
    required String translationLang}) async {
  var surah = await getDataSource().getSurahContent(
      surahNumber: surahNumber.toString(), translationLang: translationLang);
  var aya = surah.aya![ayaNumber];
  aya.translation = surah.ayaTranslation?[ayaNumber].text ?? '';
  aya.transliteration = surah.ayaTransliteration?[ayaNumber].text ?? '';
  return aya;
}

String convertNumberToArabic(String input) {
  StringBuffer sb = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    sb.write(arabicDigits[input[i]] ?? input[i]);
  }
  return sb.toString();
}
