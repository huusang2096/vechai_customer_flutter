import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/models/ScrapResponse.dart';
import 'package:veca_customer/src/models/product.dart';

import 'ProductGridItemWidget.dart';

class ProductStaggeredGridView extends StatefulWidget {
  List<ScrapModel> _productsList = [];
  HomeBlocBloc _bloc;

  ProductStaggeredGridView(this._productsList, this._bloc);

  @override
  _ProductStaggeredGridViewState createState() =>
      _ProductStaggeredGridViewState();
}

class _ProductStaggeredGridViewState extends State<ProductStaggeredGridView> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.98),
          primary: true,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._productsList.length == 0
        ? _buildShimmer()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget._productsList.length,
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                ScrapModel product = widget._productsList.elementAt(index);
                return ProductGridItemWidget(
                  product: product,
                  heroTag: product.name + index.toString(),
                  bloc: widget._bloc,
                );
              },
            ));
  }
}
