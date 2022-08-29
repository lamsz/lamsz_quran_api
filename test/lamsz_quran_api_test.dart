import 'package:flutter_test/flutter_test.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('loadSurah', () async {
    var surah = await getSurahList();
    expect(surah.length, 114);
  });

  test('Search Surah Resulting in one Surah', () async {
    var surahKeyword = 'Al Fatihah';
    var surah = await searchSurah(surahKeyword);
    expect(surah.length, 1);
    expect(surah[0].nameLatin, surahKeyword);
  });

  test('Get Surah Detail', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 1, translationLang: translationLang);
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
  });

  test('Get Single Aya', () async {
    var translationLang = 'bahasa';
    var ayaData = await getAyaData(
        surahNumber: 1, ayaNumber: 1, translationLang: translationLang);
    expect(ayaData.id, 1);
    expect(ayaData.translation,
        'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.');
    expect(ayaData.arabic, 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ');
  });
}
