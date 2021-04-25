import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/map/map_bloc.dart';
import 'package:veca_customer/src/bloc/map/map_event.dart';
import 'package:veca_customer/src/bloc/map/map_state.dart';
import 'package:veca_customer/src/common/Debouncer.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/place_model.dart';

class SearchAddressScreen extends StatefulWidget {

  final Function(Place) onSelectAddress;

  SearchAddressScreen({
    Key key,
    this.onSelectAddress
  }) : super(key: key);

  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> with UIHelper{
  MapBloc _bloc;
  TextEditingController _textFromController;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    _bloc = BlocProvider.of<MapBloc>(context);
    _textFromController = TextEditingController();
    _textFromController.addListener(() {
      _debouncer.run(() {
        _bloc.add(SearchPlaceEvent(_textFromController.text));
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace:   Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: getLinearGradient())),
          elevation: 0,
          title: Text(
            localizedText(context, 'search_address'),
            style: Theme.of(context)
                .textTheme
                .headline4
                .merge(TextStyle(color: Theme.of(context).primaryColor),)),
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    localizedText(context, 'skip'),
                    style: Theme.of(context).textTheme.button.merge(TextStyle(color: Theme.of(context).accentColor)),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              buildForm(),
              Container(
                height: 20,
                color: Color(0xfff5f5f5),
              ),
              buildAddress()
            ],
          ),
        ));
  }

  Widget buildAddress() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return _bloc.listPlace != null ? Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _bloc.listPlace?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_bloc.listPlace[index].name, style: Theme.of(context)
                    .textTheme
                    .bodyText1),
                subtitle: Text(_bloc.listPlace[index].formattedAddress,style: Theme.of(context)
                    .textTheme
                    .bodyText2),
                onTap: (){
                  widget.onSelectAddress(_bloc.listPlace[index]);
                  Navigator.of(context).pop();
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.green.withOpacity(0.5),
            ),
          ),
        ) : Container(height: 100 ,child: Center(child: Text(localizedText(context, 'finding'),
            style: Theme.of(context).textTheme.headline4),));
      },
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 0,child: Icon(
              Icons.search,
              color: Theme.of(context).accentColor
          ),),
          SizedBox(width: 10),
          Flexible(flex: 1, child:  TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              hintStyle: Theme.of(context).textTheme.subtitle2.merge(
              TextStyle(color: Theme.of(context).accentColor),
            ),
              hintText: localizedText(context, 'input_name_address'),
            ),
            controller: _textFromController,
            textInputAction: TextInputAction.search,
          ),)
        ],
      ),
    );
  }
}
