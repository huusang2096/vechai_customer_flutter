import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class CustomDialog2 extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String buttonClose;
  final Image image;
  final Function onPress;
  final Function onClose;

  CustomDialog2(
      {this.title,
      this.description,
      this.buttonText,
        this.buttonClose,
      this.image,
      this.onPress, this.onClose});

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
                          topLeft:  const  Radius.circular(30),
                          topRight: const  Radius.circular(30)),
                      gradient: getLinearGradient(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: this.image,
                    )),
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 26),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.headline4.merge(
                      TextStyle(color: Color(0xFF282828), fontSize: 20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height:50),
                Container(
                  width: 150,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    gradient: getLinearGradient(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: this.onPress,
                    child: Center(
                      child: Text(
                        buttonText,
                        style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(
                              color: Colors.white,fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10),
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
                        buttonClose,
                        style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(
                              color: Colors.white,fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
