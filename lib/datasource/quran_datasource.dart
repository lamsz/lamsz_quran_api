import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/surah_header_model.dart';
import '../model/surah_content_model.dart';

class QuranDatasource {
  var packageName = 'lamsz_quran_api';
  Future<List<SurahHeaderModel>> getSurahList() async {
    List<SurahHeaderModel> surahList = [];
    String data = await rootBundle
        .loadString('packages/$packageName/lib/assets/quran_surah.json');
    var dataList = json.decode(data);
    for (var e in dataList) {
      surahList.add(SurahHeaderModel.fromJson(e));
    }
    return surahList;
  }

  Future<SurahContentModel> getSurahContent(
      {required String surahNumber, required String translationLang}) async {
    var surah = await getSurahArabicContent(surahNumber);
    var surahTranslation = await getSurahTranslationContent(
        surahNumber: surahNumber, lang: translationLang);
    var surahTransliteration = await getSurahTranslationContent(
        surahNumber: surahNumber, lang: 'transliteration');
    surah.setAyaTranslation(surahTranslation);
    surah.setAyaTransliteration(surahTransliteration);

    return surah;
  }

  Future<SurahContentModel> getSurahArabicContent(String surahNumber) async {
    SurahContentModel surahArabic = SurahContentModel();
    String data = await rootBundle.loadString(
        'packages/$packageName/lib/assets/surah/arabic_verse_uthmani$surahNumber.json');
    var dataList = json.decode(data);
    surahArabic = SurahContentModel.fromJson(dataList);
    return surahArabic;
  }

  Future<List<AyaTranslation>> getSurahTranslationContent(
      {required String surahNumber, required String lang}) async {
    var jsonPath =
        'packages/$packageName/lib/assets/translation_$lang/translation_$lang$surahNumber.json';
    String data = await rootBundle.loadString(jsonPath);
    var dataList = json.decode(data);
    var surahTranslation = SurahContentModel.fromJson(dataList);
    return surahTranslation.ayaTranslation!;
  }
}
