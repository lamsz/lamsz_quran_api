import 'package:flutter/material.dart';
import 'package:lamsz_quran_api/lamsz_quran_api.dart';

import 'quran_content.dart';

class Quran extends StatefulWidget {
  final Color? themeColor;
  final String? translationLang;
  const Quran({Key? key, this.themeColor, this.translationLang})
      : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  List<SurahHeaderModel> surahList = [];
  List<SurahHeaderModel> searchList = [];
  bool isLoadingSurahList = false;
  TextEditingController searchController = TextEditingController();
  bool isSearchOn = false;
  late Color themeColor;
  late String translationLang;

  @override
  void initState() {
    getListOfSurah();
    themeColor = widget.themeColor ?? Colors.blue;
    translationLang = widget.translationLang ?? 'bahasa';

    super.initState();
  }

  getListOfSurah() async {
    isLoadingSurahList = true;
    surahList = await getSurahList();
    setState(() {
      searchList = surahList;
      isLoadingSurahList = false;
    });
  }

  filterText(String text) {
    return text
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('aa', 'a')
        .replaceAll("'", '')
        .replaceAll('uu', 'u')
        .replaceAll('jj', 'j')
        .replaceAll('to', 'tha')
        .replaceAll('tho', 'tha')
        .replaceAll('asy', 'as')
        .replaceAll('sh', 's')
        .replaceAll('thi', 'ti')
        .replaceAll('ii', 'i')
        .replaceAll('ff', 'f')
        .replaceAll('gho', 'gha')
        .replaceAll('gh', 'g')
        .replaceAll('kh', 'h')
        .replaceAll('ts', 's')
        .replaceAll('dz', 'z')
        .replaceAll('thu', 'tu')
        .replaceAll('gho', 'gha')
        .replaceAll('go', 'gha')
        .replaceAll('qq', 'q')
        .replaceAll('dd', 'd')
        .replaceAll('dh', 'd');
  }

  searchSurahName(String text) {
    isLoadingSurahList = true;
    searchList = surahList
        .where((element) =>
            filterText(element.nameLatin!).contains(filterText(text)))
        .toList();
    setState(() {
      searchList = searchList;
      isLoadingSurahList = false;
    });
  }

  resetList() {
    setState(() {
      searchList = surahList;
      searchController.text = '';
    });
  }

  turnOnSearch() {
    setState(() {
      isSearchOn == false ? isSearchOn = true : isSearchOn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Surah'),
          backgroundColor: themeColor,
        ),
        body: isLoadingSurahList
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  isSearchOn
                      ? Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: searchController,
                                  onSubmitted: (val) {
                                    searchSurahName(val);
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'type surah name here',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              style: BorderStyle.solid,
                                              width: 0.5))),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: IconButton(
                                  onPressed: () {
                                    resetList();
                                  },
                                  icon: const Icon(Icons.restore)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: IconButton(
                                  onPressed: () {
                                    turnOnSearch();
                                  },
                                  icon: const Icon(Icons.cancel)),
                            )
                          ],
                        )
                      : Row(children: [
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                turnOnSearch();
                              },
                              icon: const Icon(Icons.search)),
                        ]),
                  Expanded(
                      child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context, i) {
                            return listSurah(i, context);
                          })),
                ],
              ));
  }

  Padding listSurah(int i, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
          color: (i % 2 == 1)
              ? themeColor.withOpacity(0.15)
              : themeColor.withOpacity(0.03),
          child: Center(
            child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuranContent(
                                surahList: searchList,
                                indexSurah: i,
                                surahNumber: searchList[i].id!,
                                surahArabicName: searchList[i].nameArabic!,
                                surahTranslationName: searchList[i].nameLatin!,
                                themeColor: themeColor,
                                translationLang: translationLang,
                              )));
                },
                leading: Text((searchList[i].id).toString()),
                title: Text(searchList[i].nameLatin!,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
                subtitle: Text(
                    '${searchList[i].type!} || ${searchList[i].ayah} ayah'),
                trailing: Text(
                  searchList[i].nameArabic!,
                  style: const TextStyle(fontSize: 25),
                )),
          )),
    );
  }
}
