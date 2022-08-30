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

  //test functionality
  test('loadSurah', () async {
    var surah = await getSurahList();
    expect(surah.length, 114);
  });

  test('Search Surah Resulting in one Surah', () async {
    var toStringData = '    surahNo:1, \n'
        '    surahNoArabic: ١, \n'
        '    name: الفاتحة,\n'
        '    name_latin: Al Fatihah,\n'
        '    numOfAyah: 7, \n'
        '    SurahType: Makkiyah,\n'
        '    Transliteration: Al Fatihah, \n'
        '    AudioUrl: https://server8.mp3quran.net/afs/001.mp3';
    var surahKeyword = 'Al Fatihah';
    var surah = await searchSurah(surahKeyword);
    expect(surah.length, 1);
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

  //use domain test -
  //boundary value analysis and equivalence class partitioning
  //surah
  test('Get Surah Detail Low Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 1, translationLang: translationLang);
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
  });

  test('Get Surah Detail High Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 114, translationLang: translationLang);
    expect(surahData.aya!.length, 6);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
    expect(surahData.toJson().isEmpty, false);
  });

  test('Get Invalid Surah Detail Higher Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 115, translationLang: translationLang);
    expect(surahData.aya, null);
  });

  test('Get Invalid Surah Detail Lower Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 0, translationLang: translationLang);
    expect(surahData.aya, null);
  });

  //aya test
  test('Get Aya Invalid Surah Lower Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 0, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  test('Get Aya Invalid Aya Higher Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 10, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  test('Get Aya Invalid Aya Lower Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 0, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  test('Get Aya Invalid Surah Lower Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 115, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  test('Get First Surah Single Aya', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, 1);
    expect(ayaData.arabicIndex, '\u0661');
    expect(ayaData.translation,
        'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.');
    expect(ayaData.arabic, 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ');
    expect(ayaData.toJson().isEmpty, false);
  });

  test('Get Last Surah Single Aya', () async {
    var toStringData = '     id: 1, \n'
        '     arabicIndex: ١,\n'
        '     arabicText: قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ,\n'
        '     translation: Katakanlah: "Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia., \n'
        '     translliteration: qul a\'uu<u>dz</u>u birabbi <strong>al</strong>nn<u>aa</u>s<strong>i</strong>,\n'
        '     audioURL : ';
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 114, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, 1);
    expect(ayaData.translation,
        'Katakanlah: \"Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia.');
    expect(ayaData.arabic, 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ');
    expect(ayaData.toString(), toStringData);
  });
}
