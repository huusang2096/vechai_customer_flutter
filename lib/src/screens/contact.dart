import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/about_bloc.dart';
import 'package:veca_customer/src/bloc/about_event.dart';
import 'package:veca_customer/src/bloc/about_state.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AboutResponse.dart';
import 'package:veca_customer/src/widgets/FaqItemWidget.dart';

class ContactWidget extends StatefulWidget {
  @override
  _ContactwidgetState createState() => _ContactwidgetState();

  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutBloc(),
      child: ContactWidget(),
    );
  }

}

class _ContactwidgetState extends State<ContactWidget> with UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AboutBloc _bloc;
  AboutResponse aboutData;

  @override
  void initState() {
    _bloc = BlocProvider.of<AboutBloc>(context);
    _bloc.add(GetAboutData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _launchEmail() async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: aboutData == null ? 'plveca2020@gmail.com' : aboutData.data.supportEmail,
      );
      String  url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print( 'Could not launch $url');
      }
    }

    _callPhone(String number) async {
      if (await canLaunch("tel:" + number)) {
        await launch("tel:" + number);
      } else {
        throw 'Could not Call Phone';
      }
    }

    return BlocListener<AboutBloc, BaseState>(
        listener: (context, state) {
          handleCommonState(context, state);
          if (state is GetAboutDataSucces) {
            aboutData = state.aboutResponse;
          }
        }, child:
    BlocBuilder<AboutBloc, BaseState>(builder: (context, state) {
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
              title:  Text(
                localizedText(context, 'contact'),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
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
                            padding: EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
                            decoration: BoxDecoration(
                                gradient: getLinearGradient(),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5))),
                            child: Text(
                              localizedText(
                                  context, 'contact_us'),
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
                              child: Column(children: <Widget>[
                                ListTile(
                                  dense: true,
                                  onTap: (){
                                    _callPhone(aboutData == null ? "" : aboutData.data.supportPhone);
                                  },
                                  title: Row(
                                    children: <Widget>[
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.07,
                                        width: MediaQuery.of(context).size.height * 0.07,
                                        decoration: BoxDecoration(
                                          gradient: getLinearGradient(),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:   Icon(
                                              Icons.phone,
                                              size: 22,
                                              color: Colors.white,
                                            ),),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        localizedText(
                                            context, 'phone_number'),
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    aboutData != null ? aboutData.data.supportPhone : "",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                SizedBox(width: 10),
                                ListTile(
                                  dense: true,
                                  onTap: (){
                                    _launchEmail();
                                  },
                                  title: Row(
                                    children: <Widget>[
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.07,
                                        width: MediaQuery.of(context).size.height * 0.07,
                                        decoration: BoxDecoration(
                                          gradient: getLinearGradient(),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child:   Icon(
                                            Icons.email,
                                            size: 22,
                                            color: Colors.white,
                                          ),),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        localizedText(
                                            context, 'email'),
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    aboutData != null ? aboutData.data.supportEmail : "",
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(width: 10),
                                ListTile(
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.07,
                                          width: MediaQuery.of(context).size.height * 0.07,
                                          decoration: BoxDecoration(
                                            gradient: getLinearGradient(),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:   Icon(
                                              UiIcons.placeholder,
                                              size: 22,
                                              color: Colors.white,
                                            ),),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          localizedText(
                                              context, 'customer_address'),
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    trailing:
                                    SizedBox(width: 100,child: Text(
                                      aboutData != null ? aboutData.data.companyAddress : "",
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),)
                                ),
                              ],)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    }));
  }
}
