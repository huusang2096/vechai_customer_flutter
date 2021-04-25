import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/Images.dart';
import 'package:veca_customer/src/models/ScrapDetailResponse.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:webview_flutter/webview_flutter.dart';

class ProductDetailWidget extends StatefulWidget {

  ScrapDetailModel scrapDetailModel;

  ProductDetailWidget(this.scrapDetailModel);

  @override
  _ProductDetailWidgetState createState() =>
      _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  TrackingScrollController _trackingScrollController;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  double _opacityAppBar = 0;
  int currentTab = 0;

  List<Images> images = [];

  @override
  void initState() {
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
    _trackingScrollController = TrackingScrollController();
    _tabController.addListener(_handleTabSelection);
    images.add(new Images(widget.scrapDetailModel.image));
    super.initState();

    _trackingScrollController.addListener(() {
      double currentScroll = _trackingScrollController.position.pixels;
      if (currentScroll <= 0) {
        setState(() {
          _opacityAppBar = 0;
        });
      } else {
        setState(() {
          _opacityAppBar = 1;
        });
      }
    });
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _selectTab(int id) async {
      if(id == 2){
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
        Navigator.of(context).pop(0);
      } else {
        Navigator.of(context).pop(id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          localizedText(context, 'list_scrap_price'),
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
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Theme.of(context).accentColor)),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      key: _scaffoldKey,
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: kToolbarHeight),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.scrapDetailModel.image),
                            fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        widget.scrapDetailModel.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline4,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFe3e3e3),
                        border: Border.all(color: Color(0xFF999998), width: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: HtmlWidget(
                        widget.scrapDetailModel.description ?? '',
                        webView: true,
                        textStyle: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17)),
                      ),
                    )
                  ],
                )
            ),
          ),
        ],),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            gradient: getLinearGradient()),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFFdce260),
          unselectedItemColor: Colors.white,
          selectedLabelStyle: Theme.of(context).textTheme.caption,
          unselectedLabelStyle: Theme.of(context).textTheme.caption,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (int i) {
            _selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('img/home.png',
                  width: 25, color: currentTab != 0 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'home'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/notification.png',
                  width: 20, color: currentTab != 1 ?  Colors.white :  Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'notification'),
              ),
            ),
            BottomNavigationBarItem(
                title: new Container(height: 0.0),
                icon: new Container(
                  width: 70,
                )),
            BottomNavigationBarItem(
              icon: Image.asset('img/history.png',
                  width: 25,color: currentTab != 3 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'my_orders_menu'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/user.png',
                  width: 25, color: currentTab != 4 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'profile'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: 80,
          height: 100,
          child: FloatingActionButton(
            onPressed: () {
              _selectTab(2);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: getLinearGradientButton(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: Colors.white,
                    width: 2,
                    style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Text(localizedText(context, 'sell'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .merge(TextStyle(color: Color(0xFF003428)))),
                ),
              ),
            ),
          )
      ),
    );
  }
}
