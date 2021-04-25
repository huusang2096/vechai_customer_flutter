
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/notification.dart';

class NotificationItemWidget extends StatefulWidget {
  NotificationItemWidget({Key key, this.notification, this.onDismissed, this.changeTab, this.delete})
      : super(key: key);
  final NotificationData notification;
  final ValueChanged<NotificationData> onDismissed;
  final void Function(int tabId) changeTab;
  final void Function(int id) delete;


  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> with UIHelper{
  _calculationTimeAgeNotification(milliseconds) {
    final dateTimeAgo = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return timeago.format(dateTimeAgo);
  }

  _openNotificationDetail(NotificationData notificationdata) async {
    final indexTab = await   Navigator.of(context).pushNamed(RouteNamed.DETAIL_NOTIFICATIONS, arguments: widget.notification);
    if(indexTab != null){
      widget.changeTab(indexTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openNotificationDetail(widget.notification);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        // color: this.widget.notification.read ? Colors.transparent : Theme.of(context).focusColor.withOpacity(0.15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Dismissible(
          key: UniqueKey(),
          confirmDismiss: (DismissDirection dismissDirection) async {
            widget.delete(widget.notification.id);
          },
          background: Container(color: Colors.red),
          direction: DismissDirection.endToStart,
          secondaryBackground: Container(
            color: Colors.red,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    ' ${localizedText(context, 'delete')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    gradient: getLinearGradient()),
                                child: Icon(
                                  Icons.email,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(widget.notification.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText1
                          ),
                          Text(
                            widget.notification.message,
                            // _calculationTimeAgeNotification(widget.notification.time),
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            widget.notification.time,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: Colors.black12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
