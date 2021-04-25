import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/models/RequestItems.dart';

// ignore: must_be_immutable
class OrderListItemWidget extends StatefulWidget {
  String heroTag;
  OrderModel order;
  final void Function(int tabId) changeTab;

  OrderListItemWidget({Key key, this.heroTag, this.order, this.changeTab})
      : super(key: key);

  @override
  _OrderListItemWidgetState createState() => _OrderListItemWidgetState();
}

class _OrderListItemWidgetState extends State<OrderListItemWidget>
    with UIHelper {
  @override
  Widget build(BuildContext context) {
    _showDetai() async {
      final id = await Navigator.of(context)
          .pushNamed(RouteNamed.ORDER_TRASH_DETAIL, arguments: widget.order);
      if (id != null) {
        widget.changeTab(id);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Material(
          elevation: 14.0,
          borderRadius: BorderRadius.circular(2.0),
          shadowColor: Color(0x802196F3),
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).hintColor, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: () {
                  _showDetai();
                },
                leading: Image.asset('img/icon_address.png',
                    color: Theme.of(context).accentColor, width: 40),
                title: Text(
                    widget.order.acceptedBy == null
                        ? ""
                        : widget.order.acceptedBy.name +
                            " - " +
                            widget.order.acceptedBy.id.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.left),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.order == null
                          ? ""
                          : formatTime(widget.order.acceptedAt),
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    widget.order.address.addressDescription != "ghichu"
                        ? Text(widget.order.address.addressDescription,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Theme.of(context).accentColor)),
                            textAlign: TextAlign.left,
                            maxLines: null)
                        : SizedBox.shrink(),
                    Text(widget.order.address.localName,
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
