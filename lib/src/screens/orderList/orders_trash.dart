import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/orders_bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:veca_customer/src/widgets/OrderTrashtemWidget.dart';

class OrdersTrashWidget extends StatefulWidget  {
  final void Function(int tabId) changeTab;
  OrdersBloc ordersBloc;

  @override
  _OrdersTrashWidgetState createState() => _OrdersTrashWidgetState();

  OrdersTrashWidget({Key key,this.ordersBloc, this.changeTab}) : super(key: key);

  static provider(BuildContext context,OrdersBloc bloc,{void Function(int tabID) changeTab}) {
    return OrdersTrashWidget(ordersBloc: bloc,changeTab: changeTab);
  }
}

class _OrdersTrashWidgetState extends State<OrdersTrashWidget>  with UIHelper{
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc .add(OrderEvent("pending"));
    intUI();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    widget.ordersBloc .add(OrderEvent("pending"));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, BaseState>(
        listener: (context, state) {
          handleCommonState(context, state);

          if(state is DeleteOrderSuccessState){
            showToast(context, state.message);
            widget.ordersBloc .add(OrderEvent("pending"));
          }
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
      if (widget.ordersBloc.ordersPendding.isEmpty) {
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
              itemCount: widget.ordersBloc.ordersPendding.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderTrashItemWidget(
                  heroTag: 'orders_list',
                  order: widget.ordersBloc.ordersPendding[index],
                  bloc: widget.ordersBloc ,
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
