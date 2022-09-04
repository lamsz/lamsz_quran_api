import 'package:flutter/material.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';
import 'package:lamsz_quran_api/model/surah_content_model.dart';
import 'package:lamsz_quran_api/model/surah_header_model.dart';

import '../util/preference.dart';
import 'settings.dart';

class QuranContent extends StatefulWidget {
  final List<SurahHeaderModel> surahList;
  final int indexSurah;
  final int surahNumber;
  final String surahArabicName;
  final String surahTranslationName;
  final Color themeColor;
  final String translationLang;
  const QuranContent(
      {Key? key,
      required this.surahList,
      required this.indexSurah,
      required this.surahNumber,
      required this.surahArabicName,
      required this.surahTranslationName,
      required this.themeColor,
      required this.translationLang})
      : super(key: key);

  @override
  State<QuranContent> createState() => _QuranContentState();
}

class _QuranContentState extends State<QuranContent> {
  var surah = SurahContentModel();

  bool isLoadingSurahContent = false;

  static const String basmallah = "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ";
  static const String bismillah = 'Bismillahirrohmanirrohiim';
  static const int alfatihah = 1;
  static const int attaubah = 9;
  static const String frame = 'lib/assets/images/smallframe.png';
  String translationLang = '';
  bool? showTranslation;
  bool? showTransliteration;
  double? fontSize;
  int surahNumber = 1;
  String? surahArabicName;
  String? surahLatinName;

  @override
  void initState() {
    isLoadingSurahContent = true;
    initContent();
    surahNumber = widget.surahNumber;
    surahArabicName = widget.surahArabicName;
    surahLatinName = widget.surahList[widget.indexSurah].nameLatin;
    super.initState();
  }

  initContent() async {
    translationLang = (await getLanguagePreferences() ?? 'bahasa');
    showTranslation = await getTranslationPreferences();
    showTransliteration = await getTransliterationPreferences();
    fontSize = await getFontSizePreferences();
    getSurahContent();
  }

  //this used for callback
  callBackInitContent(
      String lang, double newFontSize, bool translation, bool transliteration) {
    setState(() {
      // only need to reload if there is content update
      bool isReload = (translation != showTranslation ||
              transliteration != showTransliteration) ||
          (lang != translationLang && (translation || transliteration));
      translationLang = lang;
      setLanguagePreferences(lang);
      fontSize = newFontSize;
      setFontSizePreferences(newFontSize);
      showTranslation = translation;
      setTranslationPreferences(translation);
      showTransliteration = transliteration;
      setTransliterationPreferences(transliteration);
      if (isReload) {
        getSurahContent();
      }
    });
  }

  void getSurahContent() async {
    var surahData = await getSurahData(
      surahNumber: surahNumber,
      translationLang: showTranslation ?? false ? translationLang : null,
      transliterationLang:
          showTransliteration ?? false ? translationLang : null,
    );
    setState(() {
      surah = surahData;
      isLoadingSurahContent = false;
    });
  }

  void goToSetting() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Settings(
                  callbackTrigger: callBackInitContent,
                  themeColor: widget.themeColor,
                )));
  }

  nextSurah() {
    surahNumber < 114
        ? surahNumber = surahNumber + 1
        : surahNumber = surahNumber;
    setState(() {
      surahArabicName = widget.surahList[surahNumber - 1].nameArabic;
      surahLatinName = widget.surahList[surahNumber - 1].nameLatin;
    });
    getSurahContent();
  }

  previousSurah() {
    surahNumber > 1 ? surahNumber = surahNumber - 1 : surahNumber = surahNumber;

    setState(() {
      surahArabicName = widget.surahList[surahNumber - 1].nameArabic;
      surahLatinName = widget.surahList[surahNumber - 1].nameLatin;
    });
    getSurahContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            )),
        backgroundColor: widget.themeColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  previousSurah();
                },
                icon: const Icon(Icons.arrow_left)),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  surahArabicName ?? '',
                  style: const TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    surahLatinName ?? '',
                    style: const TextStyle(fontSize: 10),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  nextSurah();
                },
                icon: const Icon(Icons.arrow_right)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                goToSetting();
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: isLoadingSurahContent
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                surahNumber != alfatihah && surahNumber != attaubah
                    ? SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
                          child: Text(
                            basmallah,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ))
                    : const SizedBox(height: 20, child: Text('')),
                surahNumber != alfatihah && surahNumber != attaubah
                    ? const SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.0, bottom: 8.0),
                          child: Text(
                            bismillah,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    : const SizedBox(height: 20, child: Text('')),
                Expanded(
                  child: ListView.builder(
                      itemCount: surah.aya!.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 3.0, right: 3.0),
                          child: Container(
                            color: (i % 2 == 1)
                                ? widget.themeColor.withOpacity(0.03)
                                : widget.themeColor.withOpacity(0.15),
                            child: ListTile(
                              leading: Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          opacity: 0.8,
                                          image: AssetImage(frame))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      surah.aya![i].arabicIndex,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                              title: Text(
                                surah.aya![i].arabic ?? '',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: fontSize),
                              ),
                              subtitle: Column(
                                children: [
                                  Visibility(
                                    visible: showTranslation!,
                                    child: Text(surah.aya![i].translation ?? '',
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                    visible: showTransliteration!,
                                    child: Text(
                                        (surah.aya![i].transliteration ?? '')
                                            .replaceAll(
                                                '<strong>a</strong>', '')
                                            .replaceAll(
                                                '<strong>al</strong>', '')
                                            .replaceAll('</strong>', '')
                                            .replaceAll('<strong>', '')
                                            .replaceAll('</u>', '')
                                            .replaceAll('<u>', ''),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
