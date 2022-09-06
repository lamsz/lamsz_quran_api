import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLanguagePreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('language') ?? 'bahasa';
}

Future<bool?> getTranslationPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('translation') ?? true;
}

Future<bool?> getTransliterationPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('transliteration') ?? false;
}

Future<double?> getFontSizePreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getDouble('fontSize') ?? 23;
}

setLanguagePreferences(String language) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('language', language);
}

setTranslationPreferences(bool showTranslation) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('translation', showTranslation);
}

setTransliterationPreferences(bool showTransliteration) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('transliteration', showTransliteration);
}

setFontSizePreferences(double size) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setDouble('fontSize', size);
}
