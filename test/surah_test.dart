import 'package:flutter_test/flutter_test.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //test model

  //use domain test -
  //boundary value analysis and equivalence class partitioning
  //surah

  test('Get Surah Arabic only', () async {
    var surahData = await getSurahData(
      surahNumber: 1,
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, null);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation, null);
    expect(surahData.aya?[0].transliteration, null);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation language', () async {
    var surahData =
        await getSurahData(surahNumber: 1, translationLang: 'bahasa');
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    expect(surahData.aya?[0].transliteration, null);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation language, and valid transliteration',
      () async {
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: 'bahasa',
      transliterationLang: 'bahasa',
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    // expect(surahData.aya?[0].transliteration!.isEmpty, false);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation, transliteration, and tafseer ',
      () async {
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: 'bahasa',
      transliterationLang: 'english',
      tafseer: 'jalalayn',
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    // expect(surahData.aya?[0].transliteration!.isEmpty, false);
    // expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah Detail Low Boundary', () async {
    var translationLang = 'bahasa';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: null,
      tafseer: tafseer,
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
  });

  test('Get Surah Detail High Boundary', () async {
    var translationLang = 'english';
    var tafseer = 'hilalikhan';
    var surahData = await getSurahData(
      surahNumber: 114,
      translationLang: translationLang,
      tafseer: tafseer,
      transliterationLang: translationLang,
    );
    expect(surahData.aya!.length, 6);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
    expect(surahData.toJson().isEmpty, false);
  });

  test('Get Invalid Surah Detail Higher Boundary', () async {
    var surahData = await getSurahData(surahNumber: 115);
    expect(surahData.aya, null);
  });

  test('Get Invalid Surah Detail Lower Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 0, translationLang: translationLang);
    expect(surahData.aya, null);
  });

  test('Get Surah Invalid Translation input', () async {
    var translationLang = 'invalid';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: translationLang,
      tafseer: tafseer,
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'invalid');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation, null);
  });

  test('Get Surah Online translation input', () async {
    var translationLang = 'malay';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: translationLang,
      tafseer: tafseer,
    );

    expect(surahData.translationLang, translationLang);
  });
}
