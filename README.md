- [About Lamsz Quran API](#about-lamsz-quran-api)
- [Installing](#installing)
- [Features](#features)
- [Using the API](#usage)

# About Lamsz Quran API

- Lamsz Quran API is an offline quran api which provide basic features to create an Al Quran application in Flutter

# Features

Lamsz Quran API provide several features as follows
- Getting list of surah, it contains the name, latin name, number of Aya, surah type Makkiyah/Madaniyah, audio url from mp3quran.net
- Filter List of Surah based on name keyword
- Get Single Surah Data content of a surah,
- Get single aya 
- Get translation of aya
   - english 
   - bahasa
- TODO: Get tafsir of aya

# Installing

Add Get to your pubspec.yaml file:

```yaml
dependencies:
  lamsz_quran_api:
```

Import get in files that it will be used:

```dart
import 'package:lamsz_quran_api/lamsz_quran_api.dart';
```

# Usage

## Get Surah List
Returns Al Quran data containing list of surah and its detail
Example:

```dart
getSurahList();
```

It will returns List of Surahs such as

```dart
{
surah: [
    {
      "id": "1",
      "name_arabic": "الفاتحة",
      "name_latin": "Al Fatihah",
      "asma": "الفاتحة",
      "ayah": 7,
      "type": "Makkiyah",
      "transliteration": "Al Fatihah",
      "audio": "https://server8.mp3quran.net/afs/001.mp3"
    },...]
 }
```
You could get the number of Surah in Al Quran, by get the length of the list

## Search Surah

You could filter Surah list by its name keyword

Example:

```dart
searchSurah('Fatihah');
```

It will returns List of Surahs similar to get surah list

```dart
 [
    {
      "id": "1",
      "name_arabic": "الفاتحة",
      "name_latin": "Al Fatihah",
      "asma": "الفاتحة",
      "ayah": 7,
      "type": "Makkiyah",
      "transliteration": "Al Fatihah",
      "audio": "https://server8.mp3quran.net/afs/001.mp3"
    }
 ]
```

## Get Single Surah Data
Returns Surah Data such as surah name, aya, translation and transliteration

Example:

```dart
getSurahData(surahNumber: 1, translationLang: 'bahasa');
```

Returns name, aya list, aya translation list and transliteration (latin):

```dart
 {
  "id": "1",
  "name": "الفاتحة",
  "aya": [
    {
      "id": 1,
      "arabic":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
      "translation": "Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.",
      "transliteration": "",
    },...
 ]
  
```

## Get Single Aya
Returns Aya Data such as number, arabic text, translation, transliteration

Example:

```dart
getAya(surahNumber: 1, aya: 1, translationLang: 'bahasa');
```

 Returns number, arabic text, translation, transliteration:

```dart
    {
      "id": "1",
      "text":  "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
      "translation": "Dengan Menyebut Nama Allah yang Maha Pengasih lagi Maha Penyayang"

    }
```
