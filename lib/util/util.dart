/// arabicDigits map of arabic digit representation
const Map<String, String> arabicDigits = <String, String>{
  '0': '\u0660',
  '1': '\u0661',
  '2': '\u0662',
  '3': '\u0663',
  '4': '\u0664',
  '5': '\u0665',
  '6': '\u0666',
  '7': '\u0667',
  '8': '\u0668',
  '9': '\u0669',
};

/// convertNumberToArabic converts number to arabic representation
String convertNumberToArabic(String input) {
  StringBuffer sb = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    sb.write(arabicDigits[input[i]] ?? input[i]);
  }
  return sb.toString();
}
