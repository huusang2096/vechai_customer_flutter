import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/home_bloc_bloc.dart';

import 'package:veca_customer/src/models/ScrapResponse.dart';

import 'MarqueeWidget.dart';

class ProductGridItemWidget extends StatefulWidget {
  const ProductGridItemWidget(
      {Key key,
      @required this.product,
      @required this.heroTag,
      @required this.bloc})
      : super(key: key);

  final ScrapModel product;
  final String heroTag;
  final HomeBlocBloc bloc;

  @override
  _ProductGridItemWidgetState createState() => _ProductGridItemWidgetState();
}

class _ProductGridItemWidgetState extends State<ProductGridItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        widget.bloc.add(HomeScrapDetail(widget.product.id));
      },
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).hintColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.product.image),
                      fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.product.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .merge(TextStyle(color: Theme.of(context).accentColor)),
              ),
              MarqueeWidget(
                direction: Axis.horizontal,
                child: Text(
                  widget.product.collectorPrice + "đ",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
