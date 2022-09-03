import 'package:flutter_test/flutter_test.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';
import 'package:lamsz_quran_api/model/surah_header_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //test model
  test('Surah Header Model', () async {
    var surahModel = SurahHeaderModel(
        id: 1,
        asma: '',
        audio: '',
        ayah: 0,
        nameArabic: '',
        nameLatin: '',
        transliteration: '',
        type: '');
    expect(surahModel.id, 1);
  });

  //test surah with domain testing
  test('loadSurah', () async {
    var surah = await getSurahList();
    expect(surah.length, 114);
  });

  test('Search Surah Resulting in one Surah', () async {
    var toStringData =
        '{"id":1,"name_arabic":"الفاتحة","name_latin":"Al Fatihah","asma":"الفاتحة","surahLength":7,"type":"Makkiyah","transliteration":"Al Fatihah","audio":"https://server8.mp3quran.net/afs/001.mp3"}';
    var surahKeyword = 'Al Fatihah';
    var surah = await searchSurah(surahKeyword);
    expect(surah.length, 1);
    expect(surah[0].arabicIndex, '\u0661');
    expect(surah[0].nameLatin, surahKeyword);
    expect(surah[0].toString(), toStringData);
    expect(surah[0].toJson().isEmpty, false);
  });

  test('Search Surah Resulting in several Surah', () async {
    var surahKeyword = 'Al';
    var surah = await searchSurah(surahKeyword);
    expect(surah.length > 1, true);
    expect(surah[0].nameLatin?.contains(surahKeyword), true);
  });

  test('Search Surah with invalid keyword', () async {
    var surahKeyword = 'Invalid';
    var surah = await searchSurah(surahKeyword);
    expect(surah.length, 0);
  });
}
