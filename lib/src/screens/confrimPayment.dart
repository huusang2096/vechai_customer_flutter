import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/src/common/ui_helper.dart';

class ConfrimPaymentWidget extends StatefulWidget {
  @override
  _ConfrimPaymentWidgetState createState() => _ConfrimPaymentWidgetState();
}

class _ConfrimPaymentWidgetState extends State<ConfrimPaymentWidget> with UIHelper {
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(children: <Widget>[
            Container(height: 200,width: double.infinity,
                color: Theme.of(context).accentColor),
            Container(
              height: 300,
              margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .hintColor
                          .withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: <Widget>[
                  Text(localizedText(context, 'payment_confirmation'),
                      style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontSize: 30, color: Colors.black))),
                  SizedBox(height: 10),
                  ListTile(
                    dense:true,
                    leading: Icon(
                      Icons.art_track,
                      size: 25,
                      color: Theme.of(context).accentColor,
                    ),
                    contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                    title: Text(
                        localizedText(context, "id_order"),
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left),
                    trailing: Text(
                      "#123",
                      style: TextStyle(
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        localizedText(context, 'confrim'),
                        style: Theme.of(context).textTheme.title.merge(
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                      elevation: 0,
                      minWidth: 250,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
