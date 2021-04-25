import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/BlogDetailResponse.dart';
import 'package:video_player/video_player.dart';

class BlogNotifications extends StatefulWidget {
  final BlogDetail blogDetail;

  BlogNotifications({this.blogDetail});

  @override
  _BlogNotificationsState createState() => _BlogNotificationsState();
}

class _BlogNotificationsState extends State<BlogNotifications> with UIHelper {
  VideoPlayerController _videoController;
  ChewieController _chewieController;
  int currentTab = 0;

  _configVideo() {
    _videoController = VideoPlayerController.network(widget.blogDetail.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: 3 / 2,
        autoPlay: true,
        looping: true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
    _chewieController.dispose();
  }

  @override
  void initState() {
    _configVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectTab(int id) async {
      if (id == 2) {
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
        Navigator.of(context).pop(0);
      } else {
        Navigator.of(context).pop(id);
      }
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: new BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  widget.blogDetail.image)))),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.blogDetail.title,
                          style: Theme.of(context).textTheme.headline4,
                          maxLines: null,
                        ),
                        SizedBox(height: 10),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(color: Colors.black12)),
                      ],
                    ),
                  ),
                  Chewie(
                    controller: _chewieController,
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Divider(color: Colors.black12)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HtmlWidget(widget.blogDetail.content ?? '',
                        webView: true,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .merge(TextStyle(fontSize: 17))),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            child: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).accentColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
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
