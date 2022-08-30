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

  static const _translationLangMap = {
    'bahasa': 'Bahasa Indonesia',
    'english': 'English'
  };

  static const _tafseerMap = {
    'bahasa': {'jalalayn': 'Jalalayn'}
  };

  var packageName = 'lamsz_quran_api';
  Future<List<SurahHeaderModel>> getSurahList() async {
    if (surahList.isEmpty) {
      String jsonPath = 'packages/$packageName/lib/assets/quran_surah.json';
      var dataList = await loadJsonAssets(jsonPath);
      for (var e in dataList) {
        surahList.add(SurahHeaderModel.fromJson(e));
      }
    }
    return surahList;
  }

  Future<SurahContentModel> getSurahContent(
      {required int surahNumber,
      required String translationLang,
      String? tafseer}) async {
    if (surahNumber < 1 || surahNumber > 114) {
      return SurahContentModel();
    }

    translationLang = checkAndSetLang(translationLang);
    tafseer = checkAndSetTafseer(translationLang, tafseer);

    //call if the object still empty
    if (surah.id == null || surah.id != surahNumber) {
      surah = await getSurahArabicContent(surahNumber);
      await _getAndSetTransliteration(surahNumber: surahNumber);
    }

    if (surah.translationLang == null ||
        surah.translationLang != translationLang) {
      await _getAndSetTranslation(
          surahNumber: surahNumber, translationLang: translationLang);
    }

    if (surah.tafseer == null || surah.tafseer != tafseer) {
      await _getAndSetTafseer(
          surahNumber: surahNumber,
          translationLang: translationLang,
          tafseer: tafseer);
    }
    surah.translationLang = translationLang;
    surah.tafseer = tafseer;

    return surah;
  }

  Map<String, String> get translationLanguageList => _translationLangMap;
  Map<String, Map<String, String>> get tafseerList => _tafseerMap;

  String checkAndSetLang(String translationLang) {
    //ensure that default lang returned if the request is invalid
    if (!translationLanguageList.containsKey(translationLang)) {
      translationLang = translationLanguageList.keys.toList().first;
    }
    return translationLang;
  }

  String checkAndSetTafseer(String translationLang, String? tafseer) {
    //ensure that default tafseer returned if the request is invalid
    if (!tafseerList[translationLang]!.containsKey(tafseer)) {
      tafseer = tafseerList[translationLang]!.keys.toList().first;
    }
    return tafseer!;
  }

  Future<SurahContentModel> getSurahArabicContent(int surahNumber) async {
    SurahContentModel surahArabic = SurahContentModel();
    String jsonPath =
        'packages/$packageName/lib/assets/surah/arabic_verse_uthmani$surahNumber.json';
    var dataList = await loadJsonAssets(jsonPath);
    surahArabic = SurahContentModel.fromJson(dataList);
    return surahArabic;
  }

  Future<void> _getAndSetTransliteration({required int surahNumber}) async {
    var jsonPath =
        'packages/$packageName/lib/assets/transliteration/$surahNumber.json';
    var dataList = await loadJsonAssets(jsonPath);
    surah.setAyaTransliteration((dataList['ayaTranslation']).cast<String>());
  }

  Future<void> _getAndSetTranslation(
      {required int surahNumber, required String translationLang}) async {
    var jsonPath =
        'packages/$packageName/lib/assets/translation/$translationLang/$surahNumber.json';
    var dataList = await loadJsonAssets(jsonPath);
    surah.setAyaTranslation((dataList['ayaTranslation']).cast<String>());
    surah.nameTranslation = dataList['translation'];
  }

  Future<void> _getAndSetTafseer(
      {required int surahNumber,
      required String translationLang,
      String? tafseer}) async {
    var jsonPath =
        'packages/$packageName/lib/assets/tafseer/$translationLang/$tafseer/$surahNumber.json';
    var dataList = await loadJsonAssets(jsonPath);
    surah.setAyaTafseer((dataList['ayaTranslation']).cast<String>());
  }

  Future<dynamic> loadJsonAssets(String jsonPath) async {
    String data = '';
    try {
      data = await rootBundle.loadString(jsonPath);
    } on Exception catch (e) {
      debugPrint(e.toString());
      data = '';
    }
    var dataList = json.decode(data);
    return dataList;
  }
}
