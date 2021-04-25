import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/FaqItemWidget.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace:   Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: getLinearGradient())),
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              localizedText(context, 'help_and_support'),
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
          backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Column(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      )
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Text(
                            'Hướng dẫn sử dụng ứng dụng',
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          child: Text(
                            'Hướng dẫn sử dụng ứng dụng......',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      )
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Text(
                            'Hướng dẫn đăng bài ',
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          child: Text(
                            'hướng dẫn đăng bài......',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
