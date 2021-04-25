import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veca_customer/src/bloc/notifications_bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/NotificationItemWidget.dart';
import 'package:veca_customer/src/widgets/state_widget.dart';

class NotificationsSystemScreen extends StatefulWidget {
  @override
  _NotificationsSystemScreenState createState() => _NotificationsSystemScreenState();

  NotificationsBloc notificationBloc;
  final void Function(int tabId) changeTab;

  NotificationsSystemScreen({Key key,this.notificationBloc, this.changeTab}) : super(key: key);

  static provider(BuildContext context,NotificationsBloc bloc,{void Function(int tabID) changeTab}) {
    return NotificationsSystemScreen(notificationBloc: bloc, changeTab: changeTab);
  }
}

class _NotificationsSystemScreenState extends State<NotificationsSystemScreen> with UIHelper{

  _buildNotificationEmptyWidget() {
    return SingleChildScrollView(
      child: StateWidget(
          image: Image.asset('img/bell.png',color: Theme.of(context).accentColor,),
          title: localizedText(context, 'notification_empty'),
          description: localizedText(context,'description_notification_empty')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.notificationBloc.sytemNotification == null ?
          loadingPager(context, MediaQuery.of(context).size.height)
          : (widget.notificationBloc.sytemNotification.length == 0 ? _buildNotificationEmptyWidget() : Container(
          margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0),
          child:ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            primary: false,
            itemCount:  widget.notificationBloc.sytemNotification.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return NotificationItemWidget(
                notification:  widget.notificationBloc.sytemNotification[index],
                changeTab: (id){
                  widget.changeTab(id);
                },
              );
            },
          ),)),
    );
  }
}
