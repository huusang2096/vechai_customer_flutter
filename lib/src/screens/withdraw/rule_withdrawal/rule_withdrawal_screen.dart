import 'package:flutter/material.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/widgets/line_dash.dart';

class RuleWithdrawalScreen extends StatelessWidget with UIHelper {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.security,
                    size: 20,
                    color: Colors.greenAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    localizedText(context, 'rule_withdrawal'),
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
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
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'img/momo_icon.png',
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    localizedText(context, 'momo_help'),
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                localizedText(context, 'momo_help_install1'),
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Image.asset(
                'img/Picture1.png',
              ),
              SizedBox(height: 20),
              Text(
                localizedText(context, 'momo_help_install2'),
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Image.asset(
                'img/Picture2.png',
              ),
              SizedBox(height: 20),
              Text(
                localizedText(context, 'momo_help_install3'),
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Image.asset(
                'img/Picture3.png',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: LineDash(
                  height: 1,
                  color: config.Colors().secondColor(1),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/momo_icon.png',
                        width: 50,
                      ),
                      SizedBox(height: 10),
                      Text(localizedText(context, 'install_momo'),
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    final _primaryColor = Theme.of(context).primaryColor;
    return AppBar(
      leading: IconButton(
        icon: Icon(UiIcons.return_icon, color: Theme.of(context).primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              gradient: getLinearGradient())),
      elevation: 0,
      bottomOpacity: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _primaryColor),
      title: Text(
        localizedText(context, 'title_momo'),
        style: Theme.of(context)
            .textTheme
            .headline4
            .merge(TextStyle(color: _primaryColor)),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://momoapp.page.link/vc5c5HXpT3uc6xMA8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
