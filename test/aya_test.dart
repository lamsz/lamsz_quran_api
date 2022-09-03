import 'package:flutter_test/flutter_test.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //aya test use domain and pairwise test
  //negative test, it should return empty aya
  test('Get Aya Invalid Surah Lower Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 0, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  //negative test, it should return empty aya
  test('Get Aya Invalid Aya Higher Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 10, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  //negative test, it should return aya with no tafseer
  test('Get Aya Invalid Tafseer Higher Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1,
        ayaNumber: 1,
        translationLang: translationLang,
        tafseer: 'testing');
    expect(ayaData.tafseer, '');
  });

  //negative test, it should return empty aya
  test('Get Aya Invalid Aya Lower Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 0, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  //negative test, it should return empty aya
  test('Get Aya Invalid Surah Higher Boundary', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 115, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, null);
  });

  test('Get First Surah Single Aya', () async {
    var translationLang = 'bahasa';
    var tafseer = 'jalalayn';
    var ayaData = await getAyaData(
        surahNumber: 1,
        ayaNumber: 1,
        translationLang: translationLang,
        tafseer: tafseer);
    expect(ayaData.id, 1);
    expect(ayaData.arabicIndex, '\u0661');
    expect(ayaData.translation,
        'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.');
    expect(ayaData.arabic, 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ');
    expect(ayaData.toJson().isEmpty, false);
  });

  test('Get Last Surah Single Aya', () async {
    var toStringData =
        '{"id":1,"ar":"قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ","translation":"Katakanlah: \\"Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia.","tafseer":"","transliteration":"","audio":""}';
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 114, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, 1);
    expect(ayaData.translation,
        'Katakanlah: "Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia.');
    expect(ayaData.arabic, 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ');
    expect(ayaData.toString(), toStringData);
  });
}
