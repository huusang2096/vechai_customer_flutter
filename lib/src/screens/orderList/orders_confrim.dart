import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/widgets/OrderConfrimListItemWidget.dart';

class OrdersConfirmedsWidget extends StatefulWidget  {
  final void Function(int tabId) changeTab;
  OrdersBloc ordersBloc;


  OrdersConfirmedsWidget({Key key,this.ordersBloc, this.changeTab}) : super(key: key);

  @override
  _OrdersConfirmedsWidgetState createState() => _OrdersConfirmedsWidgetState();


  static provider(BuildContext context,OrdersBloc bloc,{void Function(int tabID) changeTab}) {
    return OrdersConfirmedsWidget(ordersBloc: bloc,changeTab: changeTab);
  }
}

class _OrdersConfirmedsWidgetState extends State<OrdersConfirmedsWidget>  with UIHelper{
  String layout = 'list';

  @override
  void initState() {
    widget.ordersBloc.add(OrderEvent("finished"));
    intUI();
    super.initState();
  }


  Future<Null> _handleRefresh() async {
    widget.ordersBloc.add(OrderEvent("finished"));
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
      if (widget.ordersBloc.ordersFinish.isEmpty) {
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
              itemCount: widget.ordersBloc.ordersFinish.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return OrderConfrimListItemWidget(
                  heroTag: 'orders_list',
                  order: widget.ordersBloc.ordersFinish[index],
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
