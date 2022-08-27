import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/surah_header_model.dart';
import '../model/surah_content_model.dart';

class QuranDatasource {
  static final QuranDatasource _instance = QuranDatasource._();

  QuranDatasource._();

  static QuranDatasource get instance => _instance;
  var surahList = <SurahHeaderModel>[];
  var surah = SurahContentModel();

  var packageName = 'lamsz_quran_api';
  Future<List<SurahHeaderModel>> getSurahList() async {
    if (surahList.isEmpty) {
      debugPrint('call from json quran surah');
      String data = await rootBundle
          .loadString('packages/$packageName/lib/assets/quran_surah.json');
      var dataList = json.decode(data);
      for (var e in dataList) {
        surahList.add(SurahHeaderModel.fromJson(e));
      }
    }
    return surahList;
  }

  Future<SurahContentModel> getSurahContent(
      {required int surahNumber, required String translationLang}) async {
    //call if the object still empty
    if (surah.id == null || surah.id != surahNumber) {
      debugPrint('call json surah ${surahNumber}');
      surah = await getSurahArabicContent(surahNumber);
      var surahTransliteration = await getSurahTranslationContent(
          surahNumber: surahNumber, lang: 'transliteration');
      surah.setAyaTransliteration(surahTransliteration);
    }
    if (surah.translationLang == null ||
        surah.translationLang != translationLang) {
      var surahTranslation = await getSurahTranslationContent(
          surahNumber: surahNumber, lang: translationLang);
      surah.setAyaTranslation(surahTranslation);
      surah.translationLang = translationLang;
    }

    return surah;
  }

  Future<SurahContentModel> getSurahArabicContent(int surahNumber) async {
    SurahContentModel surahArabic = SurahContentModel();
    String data = await rootBundle.loadString(
        'packages/$packageName/lib/assets/surah_minify/arabic_verse_uthmani$surahNumber.json');
    var dataList = json.decode(data);
    surahArabic = SurahContentModel.fromJson(dataList);
    return surahArabic;
  }

  Future<List<String>> getSurahTranslationContent(
      {required int surahNumber, required String lang}) async {
    var jsonPath =
        'packages/$packageName/lib/assets/translation_${lang}_minify/translation_$lang$surahNumber.json';
    String data = await rootBundle.loadString(jsonPath);
    var dataList = json.decode(data);
    return dataList['ayaTranslation'].cast<String>();
  }
}
