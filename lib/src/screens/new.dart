import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/new_bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/models/BlogDetailResponse.dart';
import 'package:veca_customer/src/models/BlogResponse.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/BlogListItemWidget.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class NewWidget extends StatefulWidget {
  int currentTab;

  NewWidget({Key key, this.currentTab}) : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();

  static provider(BuildContext context, int currentTab) {
    return BlocProvider(
      create: (context) => NewBloc(),
      child: NewWidget(currentTab: currentTab),
    );
  }
}

class _NewWidgetState extends State<NewWidget>
    with UIHelper {
  NewBloc _bloc;
  List<BlogModel> blogs = [];
  String title  = "";
  int currentTab = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(widget.currentTab == 1){
      title = localizedText(context, 'news');
    } else if(widget.currentTab == 2){
      title = localizedText(context, 'green_living');
    } else {
      title = localizedText(context, 'knowledge');
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NewBloc>(context);
    _bloc.add(NewEvent(widget.currentTab));

    List<BlogModel> blogModels = [];
    intUI();
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return InkWell(
        onTap: onTap != null
            ? () => onTap()
            : () {
          print('Not set yet');
        },
        child: child);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    _onRefresh() {
      _bloc.add(NewEvent(widget.currentTab));
      return refreshCompleter.future;
    }

    _selectTab(int id) async {
      if(id == 2){
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
        Navigator.of(context).pop(0);
      } else {
        Navigator.of(context).pop(id);
      }
    }

    _openDetail(BlogDetail blogDetail) async {
     final id = await Navigator.of(context).pushNamed(RouteNamed.BLOG_DETAIL, arguments: blogDetail);
     if(id != null){
       _selectTab(id);
     }
    }

    return BlocListener<NewBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if(state is ListNewSuccessState){
          blogs = state.blogModels;
        }

        if(state is BlogDetailSuccessState){
          BlogDetail blogDetail = state.blogDetailModels.data;
          _openDetail(blogDetail);
        }
      },
      child: BlocBuilder<NewBloc, BaseState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05, horizontal: 0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            widget.currentTab == 1 ? _buildTile(
                                Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            gradient: getLinearGradient(),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset('img/music.png', width: 20)
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                        Text(localizedText(context, 'news'),
                                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: config.Colors().accentDarkColor(1)))),

                                      ],
                                    )
                                ),
                                onTap: (){
                                  setState(() {
                                    title = localizedText(context, 'news');
                                  });
                                  widget.currentTab = 1;
                                  _bloc.add(NewEvent(widget.currentTab));
                                }
                            ): SizedBox.shrink(),
                            widget.currentTab == 2 ? _buildTile(
                                Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            gradient: getLinearGradient(),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset('img/suggest.png', width: 20)
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                        Text(localizedText(context, 'green_living'),
                                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: config.Colors().accentDarkColor(1)))),

                                      ],
                                    )
                                ),
                                onTap: (){
                                  setState(() {
                                    title = localizedText(context, 'green_living');
                                  });
                                  widget.currentTab = 2;
                                  _bloc.add(NewEvent(widget.currentTab));
                                }
                            ):SizedBox.shrink(),
                            widget.currentTab == 3 ? _buildTile(
                                Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            gradient: getLinearGradient(),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset('img/greenLife.png', width: 20)
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                        Text(localizedText(context, 'knowledge'),
                                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: config.Colors().accentDarkColor(1)))),

                                      ],
                                    )
                                ),
                                onTap: (){
                                  setState(() {
                                    title = localizedText(context, 'knowledge');
                                  });
                                  widget.currentTab = 3;
                                  _bloc.add(NewEvent(widget.currentTab));
                                }
                            ) : SizedBox.shrink(),
                            _buildBody(state)
                          ],
                        )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: new IconButton(
                        icon: new Icon(UiIcons.return_icon,
                            color: Theme.of(context).accentColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
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
            ),);
        },
      ),
    );
  }

  _buildBody(state) {
    if (state is ErrorState) {
      return Container(
          height: 100,
          child: Center(
            child: Text(state.error),
          ));
    }
    if (state is ListNewSuccessState || state is BlogDetailSuccessState) {
      if (blogs.isEmpty) {
        return Container(
            height: 100,
            child: Center(
              child: Text(localizedText(context, 'empty'), style: Theme.of(context)
                  .textTheme
                  .headline4),
            ));
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
          child:ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            primary: false,
            itemCount: blogs.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return BlogListItemWidget(
                heroTag: blogs[index].id.toString(),
                blogModel: blogs[index],
                bloc: _bloc,
              );
            },
          ));
      }
    }
    return Container(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
