import 'package:flutter/material.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';
import 'package:lamsz_quran_api/model/surah_content_model.dart';
import 'package:lamsz_quran_api/model/surah_header_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var surahData = SurahContentModel();
  var surahListData = <SurahHeaderModel>[];
  var aya11 = Aya();
  var defaultLang = 'bahasa';
  var defaultSurah = 1;
  var defaultAyah = 1;

  loadSurah(String translationLang) async {
    var surah = await getSurahData(
        surahNumber: defaultSurah, translationLang: translationLang);
    var surahList = await getSurahList();
    var aya = await getAyaData(
        surahNumber: defaultSurah,
        ayaNumber: defaultAyah - 1,
        translationLang: translationLang);
    setState(() {
      surahData = surah;
      surahListData = surahList;
      aya11 = aya;
    });
  }

  @override
  void initState() {
    loadSurah(defaultLang);
    super.initState();
  }

  changeLang() {
    defaultLang = defaultLang == 'bahasa' ? 'english' : 'bahasa';
    loadSurah(defaultLang);
  }

  changeSurah() {
    if (defaultSurah < 114) {
      defaultSurah++;
    } else {
      defaultSurah = 1;
    }
    defaultAyah = 1;
    loadSurah(defaultLang);
  }

  changeAya() {
    if (defaultAyah < surahListData[defaultSurah - 1].ayah!) {
      defaultAyah++;
    } else {
      defaultAyah = 1;
    }
    loadSurah(defaultLang);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: changeLang, child: const Text('change language')),
              TextButton(
                  onPressed: changeSurah, child: const Text('change Surah')),
              TextButton(onPressed: changeAya, child: const Text('change Aya')),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                const Text('getSurahList()'),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: surahListData.length,
                        itemBuilder: (context, i) {
                          // return Text('test${surah.id.toString()}');
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 3.0, right: 3.0),
                            child: ListTile(
                              leading: Text(surahListData[i].arabicIndex),
                              title: Text(
                                surahListData[i].toString(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                    "getSurahData(surahNumber: $defaultSurah, translationLang: $defaultLang)"),
                Text('Surah : ${surahData.name ?? ''}'),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: (surahData.aya ?? []).length,
                        itemBuilder: (context, i) {
                          // return Text('test${surah.id.toString()}');
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 3.0, right: 3.0),
                            child: ListTile(
                              leading: Text(surahData.aya![i].arabicIndex),
                              title: Text(
                                surahData.aya![i].toString(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      """getAyaData(surahNumber: $defaultSurah, ayaNumber: $defaultAyah,
                        translationLang: $defaultLang );"""),
                  Text(aya11.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
