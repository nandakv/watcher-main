import 'html_text_model.dart';

class HtmlTextHelper {
  // i - italic
  // b - bold
  // u - underline
  // h1 - h1

  static String highlightTextFormat(String value) {
    final text = value
        .replaceAll('<i>', '%i')
        .replaceAll('</i>', '%i%')
        .replaceAll('<b>', '%b')
        .replaceAll('</b>', '%b%')
        .replaceAll('<u>', '%u')
        .replaceAll('</u>', '%u%')
        .replaceAll('<h1>', '%h1')
        .replaceAll('</h1>', '%h1%');
    return text;
  }

  static String normalizeText(String value) {
    return value.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), '');
  }

  // NOTE separates the texts.
  static List<HtmlTextModel> mountText(String value) {
    var texto = highlightTextFormat(value);
    texto = normalizeText(texto);
    List<HtmlTextModel> list = <HtmlTextModel>[];

    while (texto.isNotEmpty) {
      var i = texto.indexOf(RegExp('%p|%i|%b|%u|%h1'));
      // NOTE check if it only has text in normal format
      if (i == -1) {
        list.add(HtmlTextModel(text: texto, format: HtmlTextFormat.normal));
        break;
      }

      var fragmentOne = _getFragment(texto);

      // NOTE add
      list.add(HtmlTextModel(text: fragmentOne, format: HtmlTextFormat.normal));
      // NOTE remove the part that has already been saved
      texto = _removeFragment(texto, fragmentOne);

      // NOTE get the format of which the text is
      HtmlTextFormat format;
      if (texto.contains('%i')) {
        format = HtmlTextFormat.italic;
      } else if (texto.contains('%b')) {
        format = HtmlTextFormat.bold;
      } else if (texto.contains('%u')) {
        format = HtmlTextFormat.underline;
      } else if (texto.contains('%h1')) {
        format = HtmlTextFormat.h1;
      } else {
        format = HtmlTextFormat.normal;
      }

      // NOTE remove the first tag
      texto = _replaceStepOne(texto);
      // detecta o final
      var fragmentTwo = _getFragment(texto);

      list.add(HtmlTextModel(text: fragmentTwo, format: format));
      texto = _removeFragment(texto, fragmentTwo);

      // NOTE remove the second tag
      texto = _replaceStepTwo(texto);
    }

    return list;
  }

  static String _getFragment(String value) =>
      value.substring(0, value.indexOf(RegExp(r'%i|%b|%u|%p|%h1')));

  static String _removeFragment(String value, String fragment) =>
      value.replaceFirst(fragment, '');

  static String _replaceStepOne(String value) =>
      value.replaceFirst(RegExp(r'%i|%b|%u|%p|%h1'), '');

  static String _replaceStepTwo(String value) =>
      value.replaceFirst(RegExp(r'%i%|%b%|%u%|%p%|%h1%'), '');
}
