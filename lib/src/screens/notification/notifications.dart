import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:veca_customer/src/screens/notification/notifications_system.dart';
import 'package:veca_customer/src/screens/notification/notifications_user.dart';


class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();

  final void Function(int tabId) changeTab;
  NotificationsBloc bloc;
  NotificationsWidget(this.bloc,this.changeTab);
  int currentTab;

  static provider(BuildContext context, NotificationsBloc bloc,{void Function(int tabID) changeTab}) {
    return NotificationsWidget(bloc, changeTab);
  }
}

class _NotificationsWidgetState extends State<NotificationsWidget>
    with UIHelper {

  @override
  void initState() {
    super.initState();
    widget.bloc = BlocProvider.of<NotificationsBloc>(context);
    widget.bloc.add(NotificationEvent());
    intUI();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return BlocListener<NotificationsBloc, BaseState>(
      listener: (context, state) {
        if (state is NotificationsSuccessState) {
        }
      },
      child: BlocBuilder<NotificationsBloc, BaseState>(
        builder: (context, state) {
           return DefaultTabController(
              initialIndex: widget.currentTab ?? 0,
              length: 2,
              child: EasyLocalizationProvider(
                child: Scaffold(
                  key: _scaffoldKey,
                  appBar: new PreferredSize(
                    preferredSize: Size.fromHeight(90),
                    child: new Container(
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: config.Colors().mainDarkColor(1), width: 0.5),
                              borderRadius: BorderRadius.circular(20)),
                          child: TabBar(
                            indicatorColor: Colors.transparent,
                            indicator:  BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                    Theme.of(context).hintColor.withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 15)
                              ],
                            ),
                            indicatorWeight: 0.0,
                            unselectedLabelColor: config.Colors().secondColor(1),
                            labelColor: Colors.white,
                            labelStyle: Theme.of(context).textTheme.subtitle2,
                            unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
                            isScrollable: false,
                            tabs: <Widget>[
                              Tab(
                                child: Text(
                                  localizedText(context,'system'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tab(
                                child: Text(
                                  localizedText(context,'user'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  body: TabBarView(children: [
                    NotificationsSystemScreen.provider(context, widget.bloc,changeTab: (id){
                      widget.changeTab(id);
                    }),
                    NotificationsUserScreen.provider(context,widget.bloc,changeTab: (id){
                      widget.changeTab(id);
                    }),
                  ]),
                ),
              ));
        },
      ),
    );
  }
}
