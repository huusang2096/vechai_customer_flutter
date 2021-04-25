import 'package:flutter/material.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/models/route_argument.dart';

class OrderGridItemWidget extends StatelessWidget with UIHelper {
  OrderGridItemWidget({
    Key key,
    @required this.order,
    @required this.heroTag,
  }) : super(key: key);

  final OrderModel order;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Order',
            arguments: new RouteArgument(
                argumentsList: [this.heroTag], id: this.order.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.10),
                offset: Offset(0, 4),
                blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                ListTile(
                  title: Text(
                      order == null
                          ? ""
                          : "#" +
                              order.id.toString() +
                              " - " +
                              order.id.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.left),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        order == null ? "" : order.createdAt.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left,
                      ),
                      Text(order == null ? "" : order.status,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.left)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  // The title of the order
                  Expanded(
                    child: Text(
                      localizedText(context, 'list_trash') + ": " + "2",
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  Text(
                    "5",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
