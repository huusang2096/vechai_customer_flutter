import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:veca_customer/src/widgets/OrderGridItemWidget.dart';
import 'package:veca_customer/src/widgets/OrderListItemWidget.dart';

class OrdersProductsWidget extends StatefulWidget  {
  final void Function(int tabId) changeTab;
  OrdersBloc ordersBloc;

  OrdersProductsWidget({Key key,this.ordersBloc, this.changeTab});

  @override
  _OrdersProductsWidgetState createState() => _OrdersProductsWidgetState();

  static provider(BuildContext context,OrdersBloc bloc,{void Function(int tabID) changeTab}) {
    return OrdersProductsWidget(ordersBloc: bloc,changeTab: changeTab);
  }
}

class _OrdersProductsWidgetState extends State<OrdersProductsWidget>  with UIHelper{
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderEvent("accepted"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderEvent("accepted"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, BaseState>(
        listener: (context, state) {
          handleCommonState(context, state);

        },
        child: BlocBuilder<OrdersBloc, BaseState>(builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(children: [
                  _buildBody(state),
                ],)
            ),
          );
        }));
  }


  _buildBody(state) {
    if (state is ErrorState) {
      return Container(
          height: 100,
          child: Center(
            child: Text(state.error),
          ));
    }
    if (state is OrderSuccessState) {
      if (widget.ordersBloc.ordersConfrim.isEmpty) {
        return Container(
            height: 100,
            child: Center(
              child: Text(localizedText(context, 'order_is_empty')),
            ));
      } else {
        return Container(
            child : ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              primary: false,
              itemCount: widget.ordersBloc.ordersConfrim.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderListItemWidget(
                  heroTag: 'orders_list',
                  order: widget.ordersBloc.ordersConfrim[index],
                  changeTab: (id) {
                    widget.changeTab(id);
                  },
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
