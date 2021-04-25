import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/address/address_bloc.dart';
import 'package:veca_customer/src/bloc/address/address_event.dart';
import 'package:veca_customer/src/bloc/address/address_state.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AddressModel.dart';
import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/config/app_config.dart' as config;


class AddressWidget extends StatefulWidget {
  @override
  State<AddressWidget> createState() {
    // TODO: implement createState
    return _AddressWidgetState();
  }
}

class _AddressWidgetState extends State<AddressWidget> with UIHelper {
  ProgressDialog pr;
  AddressBloc _bloc;

  @override
  void initState() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _bloc = BlocProvider.of<AddressBloc>(context);
    _bloc.add(FetchAddressList());// TODO: implement initState
    intUI();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onRefresh() {
      _bloc.add(FetchAddressList());
      return refreshCompleter.future;
    }

    return BlocListener<AddressBloc, AddressState>(listener: (context, state) {
      if (state is FetchDataLoading) {
        pr.show();
      }

      if (state is FetchDataDismiss) {
        pr.dismiss();
      }

      if(state is LoadAddressFailure){
        showToast(context, localizedText(context, state.error));
      }

      if (state is LoadedAddress) {
        refreshCompleter?.complete();
        intUI();
      }
    }, child: BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace:   Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: getLinearGradient())),
            elevation: 0,
            title: Text(
              localizedText(context, 'address'),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
            actions: <Widget>[
              new IconButton(
                icon:
                    new Icon(Icons.add, color: Theme.of(context).primaryColor),
                onPressed: () {
                  _openMap();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            child: _buildBody(state),
            onRefresh: _onRefresh,
          ));
    }));
  }

  _openMap() async {
    var callBack = (address) {
      _bloc.add(FetchAddressList());
      return refreshCompleter.future;
    };
    Navigator.of(context).pushNamed(RouteNamed.ADDRESS_MAP, arguments: {"funcition": callBack});
  }

  _buildBody(state) {
    if (state is LoadedAddress) {
      if (state.items.isEmpty) {
        return Center(
          child: Text(localizedText(context, 'assress_is_empty')),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile(
                    item: (state is LoadedAddress) ? state.items[index] : [],
                    onDeletePressed: (addressId) {
                      _bloc.add(DeleteAddress(id: addressId));
                    },
                  );
                },
                itemCount: (state is LoadedAddress) ? state.items.length : 0,
              )),
            ],
          ),
        );
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ItemTile extends StatelessWidget {
  final AddressModel item;
  final Function(int) onDeletePressed;

  const ItemTile(
      {Key key,
      @required this.item, @required this.onDeletePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.addressTitle,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              item.addressDescription != "ghichu" ? Text(item.addressDescription,
                  style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: item.isSelect ? Colors.white : config.Colors().secondDarkColor(1))),
                  textAlign: TextAlign.left,
                  maxLines: null): SizedBox.shrink(),
              Text(
                  item.localName,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left)
            ],
          ),
          trailing: InkWell(
            onTap: (){
              onDeletePressed(item.id);
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
        SizedBox(height: 5),
        Divider(color: Colors.black12)
      ],
    );
  }
}
