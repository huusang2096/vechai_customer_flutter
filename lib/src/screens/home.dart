import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/models/ScrapDetailResponse.dart';
import 'package:veca_customer/src/models/ScrapResponse.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/MarqueeWidget.dart';
import 'package:veca_customer/src/widgets/ProductStaggeredGridViewWidget.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class HomeWidget extends StatefulWidget {
  final void Function(int tabId) changeTab;

  HomeWidget(this.changeTab);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();

  static provider(BuildContext context, {void Function(int tabID) changeTab}) {
    return BlocProvider(
      create: (context) => HomeBlocBloc(),
      child: HomeWidget(changeTab),
    );
  }
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  HomeBlocBloc _homeBloc;
  List<ScrapModel> _productsList = [];

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBlocBloc>(context);
    _homeBloc.add(HomeScrap());
    intUI();
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {
      await new Future.delayed(new Duration(seconds: 3));
      _homeBloc.add(HomeScrap());
      return null;
    }

    _launchEmail() async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'plveca2020@gmail.com',
      );
      String url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    }

    _openProductDetail(ScrapDetailModel scrapDetailModel) async {
      final indexTab = await Navigator.of(context)
          .pushNamed(RouteNamed.PRODUCT, arguments: scrapDetailModel);
      if (indexTab != null) {
        widget.changeTab(indexTab);
      }
    }

    _openNewDetail(int id) async {
      final indexTab =
          await Navigator.of(context).pushNamed(RouteNamed.NEW, arguments: id);
      if (indexTab != null) {
        widget.changeTab(indexTab);
      }
    }

    var data = EasyLocalizationProvider.of(context).data;
    return BlocListener<HomeBlocBloc, BaseState>(listener: (context, state) {
      //handleCommonState(context, state);
      if (state is GetListScrapSuccessState) {
        _productsList = state.scraps;
      }

      if (state is GetScrapDetailSuccessState) {
        _openProductDetail(state.scrapDetailResponse.data);
      }
    }, child: BlocBuilder<HomeBlocBloc, BaseState>(builder: (context, state) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('img/headerTop.png')),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTile(
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset('img/chat.png',
                                              width: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'feedback'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ],
                                )), onTap: () {
                          _launchEmail();
                        }),
                        _buildTile(
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset('img/share.png',
                                              width: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'share'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ]),
                            ), onTap: () {
                          Share.share(
                              "Ve chai công nghệ : Tiện lợi - minh bạch! Chia sẻ để VECA được nhiều người biết đến nhé: http://onelink.to/veca.app");
                        }),
                        _buildTile(
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset('img/music.png',
                                              width: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'news'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ],
                                )), onTap: () {
                          _openNewDetail(1);
                        }),
                        _buildTile(
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.asset('img/suggest.png',
                                              width: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'green_living'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ],
                                )), onTap: () {
                          _openNewDetail(2);
                        }),
                        _buildTile(
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        gradient: getLinearGradient(),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'img/greenLife.png',
                                              width: 10)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(localizedText(context, 'knowledge'),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: config.Colors()
                                                    .accentDarkColor(1))))
                                  ],
                                )), onTap: () {
                          _openNewDetail(3);
                        }),
                      ],
                    )),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(localizedText(context, 'list_scrap_price'),
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.left),
                ),
                SizedBox(height: 10),
                ProductStaggeredGridView(_productsList, _homeBloc),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      );
    }));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return InkWell(
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Not set yet');
              },
        child: child);
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, ScreenUtil().setHeight(100.0));
    path.quadraticBezierTo(size.width / 2.0, ScreenUtil().setHeight(180.0),
        size.width, ScreenUtil().setHeight(100.0));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
