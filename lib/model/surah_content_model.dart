class SurahContentModel {
  String? id;
  String? name;
  String? remark;
  List<Aya>? aya;
  List<AyaTranslation>? ayaTranslation;
  List<AyaTranslation>? ayaTransliteration;

  SurahContentModel(
      {this.id,
      this.name,
      this.remark,
      this.aya,
      this.ayaTranslation,
      this.ayaTransliteration});

  SurahContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remark = json['remark'];
    if (json['aya'] != null) {
      aya = <Aya>[];
      json['aya'].forEach((v) {
        aya!.add(Aya.fromJson(v));
      });
    }

    if (json['ayaTranslation'] != null) {
      ayaTranslation = <AyaTranslation>[];
      json['ayaTranslation'].forEach((v) {
        ayaTranslation!.add(AyaTranslation.fromJson(v));
      });
    }

    if (json['ayaTranslation'] != null) {
      ayaTransliteration = <AyaTranslation>[];
      json['ayaTranslation'].forEach((v) {
        ayaTransliteration!.add(AyaTranslation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remark'] = remark;
    if (aya != null) {
      data['aya'] = aya!.map((v) => v.toJson()).toList();
    }
    if (ayaTranslation != null) {
      data['ayaTranslation'] = ayaTranslation!.map((v) => v.toJson()).toList();
    }
    if (ayaTransliteration != null) {
      data['ayaTranslation'] =
          ayaTransliteration!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void setAyaTranslation(List<AyaTranslation> ayaTranslation) {
    for (var element in ayaTranslation) {
      var ayaTemp = aya![int.parse(element.id!) - 1];
      ayaTemp.translation = element.text;
      aya![int.parse(element.id!) - 1] = ayaTemp;
    }
    this.ayaTranslation = ayaTranslation;
  }

  void setAyaTransliteration(List<AyaTranslation> ayaTransliteration) {
    for (var element in ayaTransliteration) {
      var ayaTemp = aya![int.parse(element.id!) - 1];
      ayaTemp.transliteration = element.text;
      aya![int.parse(element.id!) - 1] = ayaTemp;
    }
    this.ayaTransliteration = ayaTransliteration;
  }
}

class Aya {
  String? id;
  String? text;
  String? remark;
  String? translation;
  String? remarkTranslation;
  String? transliteration;
  String? audioURL;

  Aya({this.id, this.text});

  Aya.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    translation = json['translation'];
    transliteration = json['transliteration'];
    audioURL = json['audioURL'];
    remark = json['remark'];
    remarkTranslation = json['remark_translation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['remark'] = remark;
    data['translation'] = translation;
    data['remark_translation'] = remarkTranslation;
    data['transliteration'] = transliteration;
    data['audioURL'] = audioURL;
    return data;
  }

  @override
  String toString() {
    return """id: $id, arabicText: $text,
     remark: ${remark ?? ''}, translation: ${translation ?? ''}, 
     remark_translation: ${remarkTranslation ?? ''}, 
     translliteration: ${transliteration ?? ''},
     audioURL : ${audioURL ?? ''}""";
  }
}

class AyaTranslation {
  String? id;
  String? text;

  AyaTranslation({this.id, this.text});

  AyaTranslation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
