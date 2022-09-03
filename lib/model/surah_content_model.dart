import 'dart:convert';

import '../util/util.dart';

class SurahContentModel {
  int? id;
  String? name;
  String? remark;
  List<Aya>? aya;
  List<String>? _ayaList;
  String? translationLang;
  String? transliterationLang;
  String? tafseer;
  String? nameTranslation;

  SurahContentModel({
    this.id,
    this.name,
    this.remark,
    this.aya,
  });

  SurahContentModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    remark = json['remark'];
    if (json['aya'] != null) {
      _ayaList = json['aya'].cast<String>();
    }
    if (_ayaList != null) {
      aya = <Aya>[];
      int number = 1;
      for (var element in _ayaList ?? []) {
        var ayaData = Aya(id: number, arabic: element);
        aya?.add(ayaData); // aya![number - 1] = ayaData;
        number++;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remark'] = remark;
    if (_ayaList != null) {
      data['aya'] = _ayaList;
    }
    return data;
  }

  void setAyaTranslation(List<String> ayaTranslation) {
    int number = 1;
    bool isEmpty = true;
    if (ayaTranslation.length == aya!.length) {
      isEmpty = false;
    }
    for (var element in aya!) {
      var ayaTemp = element;
      ayaTemp.translation = isEmpty ? '' : ayaTranslation[number - 1];
      aya![number - 1] = ayaTemp;
      number++;
    }
  }

  void setAyaTransliteration(List<String> ayaTransliteration) {
    int number = 1;
    bool isEmpty = true;
    if (ayaTransliteration.length == aya!.length) {
      isEmpty = false;
    }
    for (var element in aya!) {
      var ayaTemp = element;
      ayaTemp.transliteration = isEmpty ? '' : ayaTransliteration[number - 1];
      aya![number - 1] = ayaTemp;
      number++;
    }
  }

  void setAyaTafseer(List<String> ayaTafseer) {
    int number = 1;
    bool isEmpty = true;
    if (ayaTafseer.length == aya!.length) {
      isEmpty = false;
    }
    for (var element in aya!) {
      var ayaTemp = element;
      ayaTemp.tafseer = isEmpty ? '' : ayaTafseer[number - 1];
      aya![number - 1] = ayaTemp;
      number++;
    }
  }

  String get arabicIndex => convertNumberToArabic(id.toString());
}

class Aya {
  int? id;
  String? arabic;
  String? translation;
  String? transliteration;
  String? tafseer;
  String? audioURL;

  Aya(
      {this.id,
      this.arabic,
      this.translation,
      this.transliteration,
      this.tafseer,
      this.audioURL});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ar'] = arabic;
    data['translation'] = translation ?? '';
    data['tafseer'] = tafseer ?? '';
    data['transliteration'] = transliteration ?? '';
    data['audio'] = audioURL ?? '';
    return data;
  }

  @override
  String toString() {
    //return json model to string
    return jsonEncode(toJson());
  }

  String get arabicIndex => convertNumberToArabic(id.toString());
}
