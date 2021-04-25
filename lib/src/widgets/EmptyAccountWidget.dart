import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class EmptyAccountWidget extends StatelessWidget with UIHelper {
  EmptyAccountWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: config.App(context).appHeight(60),
      child: EasyLocalizationProvider(
        data: data,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Theme.of(context).focusColor,
                            Theme.of(context).focusColor.withOpacity(0.1),
                          ])),
                  child: Icon(
                    UiIcons.user,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: 0.4,
              child: Text(
                localizedText(context, 'sigin_to_use_feature'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .merge(TextStyle(fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(height: 50),
            FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNamed.SIGN_IN);
              },
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Theme.of(context).focusColor.withOpacity(0.15),
              shape: StadiumBorder(),
              child: Text(
                localizedText(context, 'sign_in'),
//                        textAlign: TextAlign.ce,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
