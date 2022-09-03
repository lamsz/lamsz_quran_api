import 'package:flutter_test/flutter_test.dart';
import 'package:lamsz_quran_api/api/quran_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //test model

  //use domain test -
  //boundary value analysis and equivalence class partitioning
  //surah

  test('Get Surah Arabic only', () async {
    var surahData = await getSurahData(
      surahNumber: 1,
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, null);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation, null);
    expect(surahData.aya?[0].transliteration, null);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation language', () async {
    var surahData =
        await getSurahData(surahNumber: 1, translationLang: 'bahasa');
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    expect(surahData.aya?[0].transliteration, null);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation language, and valid transliteration',
      () async {
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: 'bahasa',
      transliterationLang: 'bahasa',
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    // expect(surahData.aya?[0].transliteration!.isEmpty, false);
    expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah with valid translation, transliteration, and tafseer ',
      () async {
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: 'bahasa',
      transliterationLang: 'english',
      tafseer: 'jalalayn',
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'bahasa');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation!.isEmpty, false);
    // expect(surahData.aya?[0].transliteration!.isEmpty, false);
    // expect(surahData.aya?[0].tafseer, null);
  });

  test('Get Surah Detail Low Boundary', () async {
    var translationLang = 'bahasa';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: null,
      tafseer: tafseer,
    );
    const tafseerJalalayn = [
      "(Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang)",
      "(Segala puji bagi Allah) Lafal ayat ini merupakan kalimat berita, dimaksud sebagai ungkapan pujian kepada Allah berikut pengertian yang terkandung di dalamnya, yaitu bahwa Allah Taala adalah yang memiliki semua pujian yang diungkapkan oleh semua hamba-Nya. Atau makna yang dimaksud ialah bahwa Allah Taala itu adalah Zat yang harus mereka puji. Lafal Allah merupakan nama bagi Zat yang berhak untuk disembah. (Tuhan semesta alam) artinya Allah adalah yang memiliki pujian semua makhluk-Nya, yaitu terdiri dari manusia, jin, malaikat, hewan-hewan melata dan lain-lainnya. Masing-masing mereka disebut alam. Oleh karenanya ada alam manusia, alam jin dan lain sebagainya. Lafal 'al-`aalamiin' merupakan bentuk jamak dari lafal '`aalam', yaitu dengan memakai huruf ya dan huruf nun untuk menekankan makhluk berakal/berilmu atas yang lainnya. Kata 'aalam berasal dari kata `alaamah (tanda) mengingat ia adalah tanda bagi adanya yang menciptakannya.",
      "(Yang Maha Pengasih lagi Maha Penyayang) yaitu yang mempunyai rahmat. Rahmat ialah menghendaki kebaikan bagi orang yang menerimanya.",
      "(Yang menguasai hari pembalasan) di hari kiamat kelak. Lafal 'yaumuddiin' disebutkan secara khusus, karena di hari itu tiada seorang pun yang mempunyai kekuasaan, kecuali hanya Allah Taala semata, sesuai dengan firman Allah Taala yang menyatakan, \"Kepunyaan siapakah kerajaan pada hari ini (hari kiamat)? Kepunyaan Allah Yang Maha Esa lagi Maha Mengalahkan.\" (Q.S. Al-Mukmin 16) Bagi orang yang membacanya 'maaliki' maknanya menjadi \"Dia Yang memiliki semua perkara di hari kiamat\". Atau Dia adalah Zat yang memiliki sifat ini secara kekal, perihalnya sama dengan sifat-sifat-Nya yang lain, yaitu seperti 'ghaafiruz dzanbi' (Yang mengampuni dosa-dosa). Dengan demikian maka lafal 'maaliki yaumiddiin' ini sah menjadi sifat bagi Allah, karena sudah ma`rifah (dikenal).",
      "(Hanya Engkaulah yang kami sembah dan hanya kepada Engkaulah kami memohon pertolongan) Artinya kami beribadah hanya kepada-Mu, seperti mengesakan dan lain-lainnya, dan kami memohon pertolongan hanya kepada-Mu dalam menghadapi semua hamba-Mu dan lain-lainnya.",
      "(Tunjukilah kami ke jalan yang lurus) Artinya bimbinglah kami ke jalan yang lurus, kemudian dijelaskan pada ayat berikutnya, yaitu:",
      "(Jalan orang-orang yang telah Engkau anugerahkan nikmat kepada mereka), yaitu melalui petunjuk dan hidayah-Mu. Kemudian diperjelas lagi maknanya oleh ayat berikut: (Bukan (jalan) mereka yang dimurkai) Yang dimaksud adalah orang-orang Yahudi. (Dan bukan pula) dan selain (mereka yang sesat.) Yang dimaksud adalah orang-orang Kristen. Faedah adanya penjelasan tersebut tadi mempunyai pengertian bahwa orang-orang yang mendapat hidayah itu bukanlah orang-orang Yahudi dan bukan pula orang-orang Kristen. Hanya Allahlah Yang Maha Mengetahui dan hanya kepada-Nyalah dikembalikan segala sesuatu. Semoga selawat dan salam-Nya dicurahkan kepada junjungan kita Nabi Muhammad saw. beserta keluarga dan para sahabatnya, selawat dan salam yang banyak untuk selamanya. Cukuplah bagi kita Allah sebagai penolong dan Dialah sebaik-baik penolong. Tiada daya dan tiada kekuatan melainkan hanya berkat pertolongan Allah Yang Maha Tinggi lagi Maha Besar."
    ];
    surahData.setAyaTafseer(tafseerJalalayn);
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
    expect(surahData.aya?[0].tafseer?.isEmpty, false);
  });

  test('Get Surah Detail High Boundary', () async {
    var translationLang = 'english';
    var tafseer = 'hilalikhan';
    var surahData = await getSurahData(
      surahNumber: 114,
      translationLang: translationLang,
      tafseer: tafseer,
      transliterationLang: translationLang,
    );
    const transliterationData = [
      "Qul aAAoothu birabbi alnnasi",
      "Maliki alnnasi",
      "Ilahi alnnasi",
      "Min sharri alwaswasi alkhannasi",
      "Allathee yuwaswisu fee sudoori alnnasi",
      "Mina aljinnati wa alnnasm"
    ];
    surahData.setAyaTransliteration(transliterationData);
    expect(surahData.aya!.length, 6);
    expect(surahData.translationLang, translationLang);
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation?.isEmpty, false);
    expect(surahData.aya?[0].transliteration?.isEmpty, false);
    expect(surahData.toJson().isEmpty, false);
  });

  test('Get Invalid Surah Detail Higher Boundary', () async {
    var surahData = await getSurahData(surahNumber: 115);
    expect(surahData.aya, null);
  });

  test('Get Invalid Surah Detail Lower Boundary', () async {
    var translationLang = 'bahasa';
    var surahData =
        await getSurahData(surahNumber: 0, translationLang: translationLang);
    expect(surahData.aya, null);
  });

  test('Get Surah Invalid Translation input', () async {
    var translationLang = 'invalid';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: translationLang,
      tafseer: tafseer,
    );
    expect(surahData.arabicIndex, '\u0661');
    expect(surahData.aya!.length, 7);
    expect(surahData.translationLang, 'invalid');
    expect(surahData.aya?[0].arabic?.isEmpty, false);
    expect(surahData.aya?[0].translation, '');
  });

  test('Get Surah Online translation input', () async {
    var translationLang = 'malay';

    var tafseer = 'jalalayn';
    var surahData = await getSurahData(
      surahNumber: 1,
      translationLang: translationLang,
      transliterationLang: translationLang,
      tafseer: tafseer,
    );

    expect(surahData.translationLang, translationLang);
  });
}
