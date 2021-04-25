import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/BlogResponse.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/models/RequestItems.dart';

// ignore: must_be_immutable
class BlogListItemWidget extends StatefulWidget {
  String heroTag;
  BlogModel blogModel;
  NewBloc bloc;

  BlogListItemWidget({Key key, this.heroTag, this.blogModel, this.bloc}) : super(key: key);

  @override
  _BlogListItemWidgetState createState() => _BlogListItemWidgetState();
}

class _BlogListItemWidgetState extends State<BlogListItemWidget> with UIHelper {
  _userAvatar() {
    return CachedNetworkImageProvider(widget.blogModel.image);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
        onTap: (){
          widget.bloc.add(BlogDetailEvent(widget.blogModel.id));
        },
        child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(2.0),
            shadowColor: Color(0x802196F3),
            child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).hintColor, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: SizedBox(
                          width: 55,
                          height: 55,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(300),
                            child: CircleAvatar(backgroundImage: _userAvatar()),
                          )),
                      title: Text(widget.blogModel.title.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.left),
                      subtitle: Text(
                        widget.blogModel.slug.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left,
                      ),
                    )))),
      ),
    );
  }
}
