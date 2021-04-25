import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/language.dart';
import 'package:veca_customer/src/widgets/LanguageItemWidget.dart';

class LanguagesWidget extends StatefulWidget {
  @override
  _LanguagesWidgetState createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LanguagesList languagesList;
  @override
  void initState() {
    languagesList = new LanguagesList();
    Prefs.getLanguages().then((languageCode) {
      _updateLanguages(languageCode ?? 'en', isChange: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace:   Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        title:Text(
          localizedText(context, 'languages'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme.of(context).primaryColor)),),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  localizedText(context, 'skip'),
                  style: Theme.of(context).textTheme.button.merge(TextStyle(color: Theme.of(context).accentColor)),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: languagesList.languages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return LanguageItemWidget(language: languagesList.languages.elementAt(index), onChangeLanguage: (languageCode) {
                  _updateLanguages(languageCode);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _updateLanguages(languageCode, {isChange = true}) {
    setState(() {
      languagesList.languages.forEach((language) {
        if (language.languageCode == languageCode) {
          language.selected = true;
          if (isChange) {
            Prefs.saveLanguages(languageCode);
            if (languageCode == 'vi') {
              EasyLocalizationProvider.of(context).data.changeLocale(Locale('vi', 'VN'));
            } else if (languageCode == 'en') {
              EasyLocalizationProvider
                  .of(context)
                  .data
                  .changeLocale(Locale('en', 'US'));
            }
          }
        } else {
          language.selected = false;
        }
      });
    });
  }
}
