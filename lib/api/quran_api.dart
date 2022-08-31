import '../datasource/quran_datasource.dart';
import '../model/surah_content_model.dart';
import '../model/surah_header_model.dart';

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
/// surah:
///       [
///         {
///         "id": 1,
///         "name_arabic": "الفاتحة",
///         "name_latin": "Al Fatihah",
///         "asma": "الفاتحة",
///         "ayah": 7,
///         "type": "Makkiyah",
///         "transliteration": "Al Fatihah",
///         "audio": "https://server8.mp3quran.net/afs/001.mp3"
///         },...
///       ]
///}
///```
///
///Length of the list is the total number of surah in Al Quran.
Future<List<SurahHeaderModel>> getSurahList() {
  return QuranDatasource.instance.getSurahList();
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
///{
/// surah:
///       [
///         {
///         "id": 1,
///         "name_arabic": "الفاتحة",
///         "name_latin": "Al Fatihah",
///         "asma": "الفاتحة",
///         "ayah": 7,
///         "type": "Makkiyah",
///         "transliteration": "Al Fatihah",
///         "audio": "https://server8.mp3quran.net/afs/001.mp3"
///         },...
///       ]
///}
///```
///
///Length of the list is the total number of surah in Al Quran.
Future<List<SurahHeaderModel>> searchSurah(String text) async {
  var surahList = await QuranDatasource.instance.getSurahList();
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

///Returns Surah Data such as surah name, aya, translation, tafseer
/// and transliteration
///
///Example:
///
///```dart
///  getSurahData(surahNumber: 1, translationLang: 'bahasa', tafseer: 'jalalayn');
///```
///
/// Returns name, aya list, aya translation list and transliteration (latin),
/// or empty Surah if request not valid
///
///```dart
///{
/// "id": 1,
/// "name": "الفاتحة",
/// "remark": "...",
/// "translationLang": "bahasa",
/// "aya":
///       [
///         {
///           "id": 1,
///           "arabic_index": "\u0661",
///           "arabic":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
///           "translation": "Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.",
///           "transliteration": "...",
///         },...
///       ]
///}
///```
Future<SurahContentModel> getSurahData(
    {required int surahNumber,
    required String translationLang,
    String? tafseer}) async {
  return await QuranDatasource.instance.getSurahContent(
      surahNumber: surahNumber,
      translationLang: translationLang,
      tafseer: tafseer);
}

///Returns Aya Data such as number, arabic text, translation, transliteration
///
///Example:
///
///```dart
///getAya(surahNumber: 1, aya: 1, translationLang: 'english');
///```
///
/// Returns number, arabic text, translation, transliteration,
/// or empty Aya if not valid
///
///```dart
///{
///   "id": 1,
///   "arabic_index": "\u0661",
///   "arabic":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
///   "translation": "Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.",
///   "transliteration": ...
///}
///```
///
//
Future<Aya> getAyaData(
    {required int surahNumber,
    required int ayaNumber,
    required String translationLang,
    String? tafseer}) async {
  var arrayNumber = ayaNumber - 1;
  var surah = await QuranDatasource.instance.getSurahContent(
      surahNumber: surahNumber,
      translationLang: translationLang,
      tafseer: tafseer);
  return (surah.aya?.length ?? 0) > arrayNumber && arrayNumber >= 0
      ? surah.aya![arrayNumber]
      : Aya();
}
