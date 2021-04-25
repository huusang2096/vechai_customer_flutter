import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';

class ReviewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReviewWidgetState();
  }
}

class _ReviewWidgetState extends State<ReviewWidget> with UIHelper {
  ProgressDialog pr;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return BlocListener<CreatePassAccountBloc, BaseState>(
        listener: (context, state) {},
        child: BlocBuilder<CreatePassAccountBloc, BaseState>(
            builder: (context, state) {
          return EasyLocalizationProvider(
              data: data,
              child: Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  body: Stack(children: <Widget>[
                    Container(
                        height: 200,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        color: Theme.of(context).accentColor),
                    Container(
                      height: 450,
                      margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text(localizedText(context, 'review'),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .merge(TextStyle(
                                              fontSize: 30,
                                              color: Colors.black))),
                                  SizedBox(height: 20),
                                  TextField(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    keyboardType: TextInputType.text,
                                    maxLines: 5,
                                    textAlign: TextAlign.start,
                                    decoration: new InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .tr('Đánh giá người thu mua'),
                                      //S.of(context).email_addr,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .merge(
                                            TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ListTile(
                                    title: Text(
                                        localizedText(context, 'Xếp hạng'),
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        localizedText(context, 'send'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .merge(
                                              TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                      ),
                                      color: Theme.of(context).accentColor,
                                      elevation: 0,
                                      minWidth: 250,
                                      height: 55,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 20.0,
                      right: 20.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 0,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 0,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ])));
        }));
  }
}
