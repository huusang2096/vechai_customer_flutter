class Language {

  String englishName;
  String localName;
  String flag;
  String languageCode;
  bool selected;

  Language(this.englishName, this.localName, this.flag, this.languageCode, this.selected);

}

class LanguagesList {
  List<Language> _languages;

  LanguagesList() {
    this._languages = [
      new Language("English", "English", "img/america.png", "en", false),
      new Language("Việt Nam", "Việt Nam", "img/vietnam.png", "vi", false)
    ];
  }

  List<Language> get languages => _languages;

}
