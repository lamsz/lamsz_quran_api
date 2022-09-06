import 'package:flutter/material.dart';

import '../util/preference.dart';

class Settings extends StatefulWidget {
  final Function(String lang, double fontSize, bool showTranslation,
      bool showTransliteration) callbackTrigger;
  final Color themeColor;
  const Settings(
      {super.key, required this.callbackTrigger, required this.themeColor});

  @override
  State<Settings> createState() => _SettingsState();
}

enum LangOption { bahasa, english }

class _SettingsState extends State<Settings> {
  Function? translationLang;
  LangOption _langOption = LangOption.bahasa;
  bool showTranslation = true;
  bool showTransliteration = true;
  double fontSize = 23;

  @override
  void initState() {
    initContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
            onPressed: back,
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            )),
        backgroundColor: widget.themeColor,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text(
              'Choose Translation Language',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [
                const Text('Indonesia', style: TextStyle(fontSize: 14)),
                const Spacer(),
                Radio(
                    value: LangOption.bahasa,
                    groupValue: _langOption,
                    onChanged: (LangOption? value) {
                      setState(() {
                        _langOption = value!;
                      });
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [
                const Text('English', style: TextStyle(fontSize: 14)),
                const Spacer(),
                Radio(
                    value: LangOption.english,
                    groupValue: _langOption,
                    onChanged: (LangOption? value) {
                      setState(() {
                        _langOption = value!;
                      });
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Show Translation', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Switch(
                  value: showTranslation,
                  onChanged: toggleTranslation,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Show Transliteration',
                    style: TextStyle(fontSize: 16)),
                const Spacer(),
                Switch(
                  value: showTransliteration,
                  onChanged: toggleTransliteration,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            title: Row(
              children: [
                const Text('Arabic Font Size', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Text('${(fontSize).toInt()} pts'),
              ],
            ),
            subtitle: Slider(
              label: fontSize.toString(),
              max: 35,
              min: 18,
              value: fontSize,
              onChanged: setFontSize,
            ),
          ),
        ],
      ),
    );
  }

  void toggleTranslation(bool value) {
    setState(() {
      showTranslation = !showTranslation;
    });
  }

  void toggleTransliteration(bool value) {
    setState(() {
      showTransliteration = !showTransliteration;
    });
  }

  void setFontSize(double value) {
    setState(() {
      fontSize = value;
    });
  }

  Future<void> initContent() async {
    _langOption =
        LangOption.values.byName(await getLanguagePreferences() ?? 'bahasa');
    showTranslation = await getTranslationPreferences() ?? false;
    showTransliteration = await getTransliterationPreferences() ?? false;
    fontSize = await getFontSizePreferences() ?? 23;
    setState(() {});
  }

  void back() {
    widget.callbackTrigger(
        _langOption.name, fontSize, showTranslation, showTransliteration);
    Navigator.pop(context);
  }
}
