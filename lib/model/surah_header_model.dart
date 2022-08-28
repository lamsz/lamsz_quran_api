import '../util/util.dart';

class SurahHeaderModel {
  int? id;
  String? nameArabic;
  String? nameLatin;
  String? asma;
  int? ayah;
  String? type;
  String? transliteration;
  String? audio;

  SurahHeaderModel(
      {this.id,
      this.nameArabic,
      this.nameLatin,
      this.asma,
      this.ayah,
      this.type,
      this.transliteration,
      this.audio});

  SurahHeaderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameArabic = json['name_arabic'];
    nameLatin = json['name_latin'];
    asma = json['asma'];
    ayah = json['ayah'];
    type = json['type'];
    transliteration = json['transliteration'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_arabic'] = nameArabic;
    data['name_latin'] = nameLatin;
    data['asma'] = asma;
    data['ayah'] = ayah;
    data['type'] = type;
    data['transliteration'] = transliteration;
    data['audio'] = audio;
    return data;
  }

  @override
  String toString() {
    return '''
    surahNo:$id, 
    surahNoArabic: $arabicIndex, 
    name: $nameArabic,
    name_latin: $nameLatin,
    numOfAyah: $ayah, 
    SurahType: $type,
    Transliteration: $transliteration, 
    AudioUrl: $audio''';
  }

  String get arabicIndex => convertNumberToArabic(id.toString());
}
