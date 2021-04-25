import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/widgets/line_dash.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class OrdersConfrimDetailWidget extends StatefulWidget {
  OrderModel orderModel;

  OrdersConfrimDetailWidget({Key key, this.orderModel}) : super(key: key);

  @override
  _OrdersConfrimDetailWidgetState createState() =>
      _OrdersConfrimDetailWidgetState();
}

class _OrdersConfrimDetailWidgetState extends State<OrdersConfrimDetailWidget>
    with UIHelper {
  ProgressDialog pr;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    int currentTab = 3;

    _selectTab(int id) async {
      if (id == 2) {
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
        Navigator.of(context).pop(0);
      } else {
        Navigator.of(context).pop(id);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon,
              color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          localizedText(context, 'order_detail'),
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
      body: EasyLocalizationProvider(
        data: data,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              localizedText(context, 'collector_detail'),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.perm_identity,
                              size: 25,
                              color: Theme.of(context).accentColor,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                            title: Text(
                                localizedText(context, 'collector_name'),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left),
                            trailing: Text(
                              widget.orderModel.acceptedBy.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      color: Theme.of(context).accentColor)),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.phone,
                              size: 25,
                              color: Theme.of(context).accentColor,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                            title: Text(
                                localizedText(context, 'collector_phone'),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left),
                            trailing: Text(
                              widget.orderModel.acceptedBy.phoneNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      color: Theme.of(context).accentColor)),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.date_range,
                              size: 25,
                              color: Theme.of(context).accentColor,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                            title: Text(
                                localizedText(context, 'collector_date'),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left),
                            trailing: Text(
                              formatTime(widget.orderModel.acceptedAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      color: Theme.of(context).accentColor)),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 10),
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              localizedText(context, "order_detail"),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.art_track,
                                  size: 25,
                                  color: Theme.of(context).accentColor,
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(localizedText(context, "id_order"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  widget.orderModel.id.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.perm_identity,
                                  size: 25,
                                  color: Theme.of(context).accentColor,
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(localizedText(context, 'customer'),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  widget.orderModel.requestBy.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.date_range,
                                  size: 25,
                                  color: Theme.of(context).accentColor,
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(
                                    localizedText(context, 'date_create_order'),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  formatTime(widget.orderModel.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.report,
                                  size: 25,
                                  color: Theme.of(context).accentColor,
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 0.0,
                                    right: 10.0,
                                    left: 10.0),
                                title: Text(
                                    localizedText(context, "order_status"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left),
                                trailing: Text(
                                  localizedText(context, 'confirmed_order'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return ItemProduct(
                                item: widget.orderModel.requestItems[index],
                              );
                            },
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.orderModel.requestItems.length,
                          ),
                          SizedBox(height: 10),
                          LineDash(color: Colors.grey),
                          SizedBox(height: 10),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                            title: Text(
                                localizedText(context, "grand_total_detail"),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left),
                            trailing: Text(
                              widget.orderModel.grandTotalAmount.toString() +
                                  "đ",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(gradient: getLinearGradient()),
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
                  width: 25,
                  color: currentTab != 0 ? Colors.white : Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'home'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/notification.png',
                  width: 20,
                  color: currentTab != 1 ? Colors.white : Color(0xFFdce260)),
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
                  width: 25,
                  color: currentTab != 3 ? Colors.white : Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'my_orders_menu'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/user.png',
                  width: 25,
                  color: currentTab != 4 ? Colors.white : Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'profile'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    color: Colors.white, width: 2, style: BorderStyle.solid),
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
          )),
    );
  }
}

class ItemProduct extends StatelessWidget {
  final RequestItem item;

  _userAvatar() {
    return CachedNetworkImageProvider(item.scrap.image);
  }

  const ItemProduct({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 55,
          height: 55,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(item.scrap.image),
                  fit: BoxFit.contain),
            ),
          )),
      title: Text(item.scrap.name,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.left),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.weight.toString().replaceAll(".", ","),
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      trailing: Text(
        item.totalAmount.toString() + "đ",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
