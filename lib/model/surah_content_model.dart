import '../util/util.dart';

class SurahContentModel {
  int? id;
  String? name;
  String? remark;
  List<Aya>? aya;
  List<String>? _ayaList;
  String? translationLang;

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
    for (var element in ayaTranslation) {
      var ayaTemp = aya![number - 1];
      ayaTemp.translation = element;
      aya![number - 1] = ayaTemp;
      number++;
    }
  }

  void setAyaTransliteration(List<String> ayaTransliteration) {
    int number = 1;
    for (var element in ayaTransliteration) {
      var ayaTemp = aya![number - 1];
      ayaTemp.transliteration = element;
      // aya![number - 1] = ayaTemp;
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
  String? audioURL;

  Aya(
      {this.id,
      this.arabic,
      this.translation,
      this.transliteration,
      this.audioURL});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['arabic'] = arabic;
    data['translation'] = translation;
    data['transliteration'] = transliteration;
    data['audioURL'] = audioURL;
    return data;
  }

  @override
  String toString() {
    return """
     id: $id, 
     arabicIndex: $arabicIndex,
     arabicText: $arabic,
     translation: ${translation ?? ''}, 
     translliteration: ${transliteration ?? ''},
     audioURL : ${audioURL ?? ''}""";
  }

  String get arabicIndex => convertNumberToArabic(id.toString());
}
