import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:veca_customer/src/widgets/ToastWidget.dart';

class MomoNotification extends StatelessWidget {
  final Image image;
  final Function onClose;

  MomoNotification({this.image, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context: context),
    );
  }

  LinearGradient getLinearGradient() {
    return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          config.Colors().mainDarkColor(1),
          config.Colors().mainColor(1),
        ]);
  }

  void installMomo() {
    LaunchReview.launch(
        androidAppId: 'com.mservice.momotransfer',
        iOSAppId: 'com.mservice.momotransfer');
  }

  dialogContent({BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30),
                          topRight: const Radius.circular(30)),
                      gradient: getLinearGradient(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: this.image,
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    localizedText(context, 'title_momo'),
                    style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(color: Color(0xFF282828), fontSize: 20),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    localizedText(context, 'momo_privacy'),
                    style: Theme.of(context).textTheme.bodyText2.merge(
                          TextStyle(color: Color(0xFF282828)),
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    installMomo();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'img/momo_icon.png',
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(localizedText(context, 'install_momo'),
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 150,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFe74e0f),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: this.onClose,
                    child: Center(
                      child: Text(
                        localizedText(context, 'close'),
                        style: Theme.of(context).textTheme.headline4.merge(
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
