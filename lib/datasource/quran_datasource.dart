import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/surah_content_model.dart';
import '../model/surah_header_model.dart';

class QuranDatasource {
  static final QuranDatasource _instance = QuranDatasource._();
  static const String offline = 'offline';
  static const String online = 'online';
  var _jsonBaseURL = '';

  QuranDatasource._();
  //initiate singleton, so it won't create another object if exists
  static QuranDatasource get instance => _instance;
  var surahList = <SurahHeaderModel>[];
  var surah = SurahContentModel();

  static const _translationLangMap = {
    'bahasa': offline,
    'english': offline,
    'malay': online,
  };

  static const _transliterationLangMap = {
    'bahasa': online,
    'english': online,
  };

  static const _tafseerMap = {
    'bahasa': {
      'jalalayn': online,
      'quraish': online,
    },
    'english': {
      'hilalikhan': online,
      'shaheehinter': online,
    }
  };

  var packageName = 'lamsz_quran_api';

  String get jsonAssetURL => _jsonBaseURL.contains('http')
      ? _jsonBaseURL
      : 'https://raw.githubusercontent.com/lamsz/lamsz_quran_api/main/lib/assets';

  /// init quran, optional in case url of the assets needs to be changed
  initQuran({String? jsonAssetBaseURL}) {
    _jsonBaseURL = jsonAssetBaseURL ?? '';
  }

  /// returns list of all Quran surah and its attributes
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

  /// returns surah data, including aya, aya translation, transliteration
  /// and tafseer
  Future<SurahContentModel> getSurahContent(
      {required int surahNumber,
      String? translationLang,
      String? transliterationLang,
      String? tafseer}) async {
    if (surahNumber < 1 || surahNumber > 114) {
      return SurahContentModel();
    }

    //call if the object still empty
    if (surah.id != surahNumber) {
      surah = await getSurahArabicContent(surahNumber);
    }

    //check if need to re-retrieve or not
    if (surah.translationLang != translationLang) {
      await _getAndSetTranslation(
          surahNumber: surahNumber, translationLang: translationLang);
    }

    //check if need to re-retrieve or not
    if (surah.transliterationLang != transliterationLang) {
      await _getAndSetTransliteration(
        surahNumber: surahNumber,
        transliterationLang: transliterationLang,
      );
    }

    //check if need to re-retrieve or not
    if (surah.tafseer != tafseer) {
      await _getAndSetTafseer(
          surahNumber: surahNumber,
          translationLang: translationLang,
          tafseer: tafseer);
    }
    surah.translationLang = translationLang;
    surah.transliterationLang = transliterationLang;
    surah.tafseer = tafseer;

    return surah;
  }

  /// get surah arabic content including aya
  Future<SurahContentModel> getSurahArabicContent(int surahNumber) async {
    SurahContentModel surahArabic = SurahContentModel();
    String jsonPath =
        'packages/$packageName/lib/assets/surah/arabic_verse_uthmani$surahNumber.json';
    var dataList = await loadJsonAssets(jsonPath);
    surahArabic = SurahContentModel.fromJson(dataList);
    return surahArabic;
  }

  // set transliteration of ayas into a surah retrieved
  Future<void> _getAndSetTransliteration(
      {required int surahNumber, String? transliterationLang}) async {
    var retrievalType = _transliterationLangMap[transliterationLang ?? ''];
    //this means translation is off or invalid
    if (retrievalType == null || retrievalType == '') {
      surah.setAyaTransliteration(<String>[]);
    } else {
      var jsonPath =
          'packages/$packageName/lib/assets/transliteration/$transliterationLang/$surahNumber.json';
      if (retrievalType != offline) {
        jsonPath =
            '$jsonAssetURL/transliteration/$transliterationLang/$surahNumber.json';
      }
      var dataList = await _loadData(jsonPath, retrievalType);
      surah.setAyaTransliteration(
          (dataList['ayaTranslation'] ?? []).cast<String>());
    }
  }

  /// set translation of ayas into a surah retrieved
  Future<void> _getAndSetTranslation({
    required int surahNumber,
    String? translationLang,
  }) async {
    var retrievalType = _translationLangMap[translationLang ?? ''];
    //this means translation is off or invalid
    if (retrievalType == null || retrievalType == '') {
      surah.setAyaTranslation(<String>[]);
    } else {
      var jsonPath =
          'packages/$packageName/lib/assets/translation/$translationLang/$surahNumber.json';
      if (retrievalType != offline) {
        jsonPath =
            '$jsonAssetURL/translation/$translationLang/$surahNumber.json';
      }
      var dataList = await _loadData(jsonPath, retrievalType);
      surah.setAyaTranslation(
          ((dataList['ayaTranslation']) ?? []).cast<String>());
      surah.nameTranslation = dataList['translation'];
    }
  }

  /// set tafseer of ayas into a surah retrieved
  Future<void> _getAndSetTafseer(
      {required int surahNumber,
      String? translationLang,
      String? tafseer}) async {
    var retrievalType = _tafseerMap[translationLang]?[tafseer];
    //this means tafseer is off or invalid
    if (retrievalType == null || retrievalType == '') {
      surah.setAyaTafseer(<String>[]);
    } else {
      var jsonPath =
          'packages/$packageName/lib/assets/tafseer/$translationLang/$tafseer/$surahNumber.json';
      if (retrievalType != offline) {
        jsonPath =
            '$jsonAssetURL/tafseer/$translationLang/$tafseer/$surahNumber.json';
      }
      var dataList = await _loadData(jsonPath, retrievalType);
      surah.setAyaTafseer((dataList['ayaTranslation'] ?? []).cast<String>());
    }
  }

  /// returns json data either from assets or url
  Future<dynamic> _loadData(String jsonPath, String type) async {
    if (type == offline) {
      return await loadJsonAssets(jsonPath);
    } else {
      return await loadJsonFromURL(jsonPath);
    }
  }

  /// returns json data from preincluded json files
  Future<dynamic> loadJsonAssets(String jsonPath) async {
    String data = '';
    try {
      data = await rootBundle.loadString(jsonPath);
    } on Exception catch (e) {
      data = '';
    }
    return json.decode(data);
  }

  /// returns json data from cloud using http request
  Future<dynamic> loadJsonFromURL(String jsonURL) async {
    var url = Uri.parse(jsonURL);
    var response = await http.get(url);
    if (response.ok) {
      return json.decode(response.body);
    }
    return {};
  }
}

/// IsOk is an extension to check http response success status
extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
