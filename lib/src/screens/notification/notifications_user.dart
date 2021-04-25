import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veca_customer/src/bloc/notifications_bloc.dart';
import 'package:veca_customer/src/bloc/notifications_event.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/NotificationItemWidget.dart';
import 'package:veca_customer/src/widgets/state_widget.dart';

class NotificationsUserScreen extends StatefulWidget {
  @override
  _NotificationsUserScreenState createState() => _NotificationsUserScreenState();

  NotificationsBloc notificationBloc;
  final void Function(int tabId) changeTab;

  NotificationsUserScreen({Key key,this.notificationBloc, this.changeTab}) : super(key: key);

  static provider(BuildContext context,NotificationsBloc bloc,{void Function(int tabID) changeTab}) {
    return NotificationsUserScreen(notificationBloc: bloc, changeTab: changeTab);
  }
}

class _NotificationsUserScreenState extends State<NotificationsUserScreen> with UIHelper{

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
      child: widget.notificationBloc.userNotification == null ?
          loadingPager(context, MediaQuery.of(context).size.height)
          : (widget.notificationBloc.userNotification.length == 0 ? _buildNotificationEmptyWidget() : Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  primary: false,
                  itemCount:  widget.notificationBloc.userNotification.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return NotificationItemWidget(
                      notification:  widget.notificationBloc.userNotification[index],
                      changeTab: (id){
                        widget.changeTab(id);
                      },
                      delete:  (id){
                        widget.notificationBloc.add(RemoveNotificationItemEvent(notificationID: id));
                      },
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 16.0,
                child: InkWell(
                  child: Material(
                      color: Colors.red,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        ImageIcon(AssetImage("img/delete_all.png"), color: Colors.white, size: 28.0),
                      )),
                  onTap: (){
                    showCustomDialog2(
                        title: localizedText(context, "VECA"),
                        description: localizedText(context, 'do_you_want_remove_all'),
                        buttonText: localizedText(context, 'ok'),
                        buttonClose: localizedText(context, 'close'),
                        image: Image.asset(
                            'img/icon_warning.png',color: Colors.white),
                        context: context,
                        onPress: () {
                          hasShowPopUp = false;
                          Navigator.of(context).pop();
                          widget.notificationBloc.add(RemoveAllNotification());
                        });
                  },
                ),
              ),
            ],
          ),)),
    );
  }
}
