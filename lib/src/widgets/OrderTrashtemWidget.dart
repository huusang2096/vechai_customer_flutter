import 'package:flutter/material.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/orders_bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';

// ignore: must_be_immutable
class OrderTrashItemWidget extends StatefulWidget {
  String heroTag;
  OrderModel order;
  OrdersBloc bloc;
  final void Function(int tabId) changeTab;

  OrderTrashItemWidget({Key key, this.heroTag, this.order, this.bloc, this.changeTab}) : super(key: key);

  @override
  _OrderTrashItemWidgetState createState() => _OrderTrashItemWidgetState();
}

class _OrderTrashItemWidgetState extends State<OrderTrashItemWidget>
    with UIHelper {
  @override
  Widget build(BuildContext context) {

    _showDetai() async {
      final id = await Navigator.of(context).pushNamed(RouteNamed.ORDER_TRASH_DETAIL, arguments: widget.order);
      if(id != null){
        widget.changeTab(id);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Material(
          elevation: 14.0,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Color(0x802196F3),
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).hintColor, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                onTap: () {
                  _showDetai();
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.order == null
                          ?  ""
                          : formatTime(widget.order.createdAt),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    widget.order.address.addressDescription != "ghichu" ? Text( widget.order.address.addressDescription,
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                        textAlign: TextAlign.left,
                        maxLines: null): SizedBox.shrink(),
                    Text(
                        widget.order.address.localName,
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                        textAlign: TextAlign.left),
                  ],
                ),
                trailing: InkWell(
                  onTap: (){
                    showCustomDialog2(
                        title: localizedText(context, "VECA"),
                        description: localizedText(context, 'do_you_want_cancel'),
                        buttonText: localizedText(context, 'ok'),
                        buttonClose: localizedText(context, 'close'),
                        image: Image.asset(
                            'img/icon_warning.png',color: Colors.white),
                        context: context,
                        onPress: () {
                          hasShowPopUp = false;
                          Navigator.of(context).pop();
                          widget.bloc.add(RemoveOrderEvent(widget.order.id));
                        });
                  },
                  child: Material(
                      color: Colors.red,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Icon(Icons.delete, color: Colors.white, size: 18.0),
                      )),
                ),
              ),
            ),
          )),
    );
  }
}
