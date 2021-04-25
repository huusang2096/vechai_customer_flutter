import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/changePassword/change_password_bloc.dart';
import 'package:veca_customer/src/models/BlogDetailResponse.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/ScrapDetailResponse.dart';
import 'package:veca_customer/src/models/login_account_request.dart';
import 'package:veca_customer/src/models/notification.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/bloc/address/address_bloc.dart';
import 'package:veca_customer/src/bloc/address/address_event.dart';
import 'package:veca_customer/src/bloc/createOrder/bloc.dart';
import 'package:veca_customer/src/bloc/map/map_bloc.dart';
import 'package:veca_customer/src/bloc/tabs/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/screens/address.dart';
import 'package:veca_customer/src/screens/changePassword.dart';
import 'package:veca_customer/src/screens/confrimPayment.dart';
import 'package:veca_customer/src/screens/create_order.dart';
import 'package:veca_customer/src/screens/detail_blogs.dart';
import 'package:veca_customer/src/screens/detail_notifications.dart';
import 'package:veca_customer/src/screens/inputPassword.dart';
import 'package:veca_customer/src/screens/new.dart';
import 'package:veca_customer/src/screens/newPassword.dart';
import 'package:veca_customer/src/screens/contact.dart';
import 'package:veca_customer/src/screens/help.dart';
import 'package:veca_customer/src/screens/languages.dart';
import 'package:veca_customer/src/screens/notification/notifications.dart';
import 'package:veca_customer/src/screens/orderDetail/orderDetail.dart';
import 'package:veca_customer/src/screens/orderDetail/orderTrashDetail.dart';
import 'package:veca_customer/src/screens/orders.dart';
import 'package:veca_customer/src/screens/orderDetail/ordersConfrimDetail.dart';
import 'package:veca_customer/src/screens/otp.dart';
import 'package:veca_customer/src/screens/product/productDetail.dart';
import 'package:veca_customer/src/screens/review.dart';
import 'package:veca_customer/src/screens/search_address_screen.dart';
import 'package:veca_customer/src/screens/selectmap.dart';
import 'package:veca_customer/src/screens/signin.dart';
import 'package:veca_customer/src/screens/signup.dart';
import 'package:veca_customer/src/screens/splash.dart';
import 'package:veca_customer/src/screens/tabs.dart';
import 'package:veca_customer/src/screens/withdraw/history_withdrawal/history_withdrawal_screen.dart';
import 'package:veca_customer/src/screens/withdraw/rule_withdrawal/rule_withdrawal_screen.dart';
import 'package:veca_customer/src/screens/withdraw/withdraw_screen.dart';
import 'package:veca_customer/src/widgets/BasePageRoute.dart';

import 'src/models/Shop.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    final Repository repository = Repository.instance;

    switch (settings.name) {
      case RouteNamed.ROOT:
        return BasePageRoute(
            builder: (_) => SplashScreenWidget(),
            settings: RouteSettings(name: settings.name));
      case RouteNamed.SIGN_IN:
        return MaterialPageRoute(
            builder: (context) {
              return SignInWidget.provider(context);
            },
            settings: settings);
      case RouteNamed.SIGN_UP:
        return MaterialPageRoute(
            builder: (context) {
              return SignUpWidget.provider(context);
            },
            settings: settings);
      case RouteNamed.ADDRESS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                  create: (BuildContext context) =>
                      AddressBloc(repository: repository)
                        ..add(FetchAddressList()),
                  child: AddressWidget());
            },
            settings: settings);
      case RouteNamed.INPUT_PASS:
        return MaterialPageRoute(
            builder: (context) {
              return InputPasswordWidget.provider(
                  context, args as LoginAccountRequest);
            },
            settings: settings);
      case RouteNamed.PRODUCT:
        return MaterialPageRoute(
            builder: (context) {
              return ProductDetailWidget(args as ScrapDetailModel);
            },
            settings: settings);
      case RouteNamed.LANGUAGES:
        return MaterialPageRoute(
            builder: (_) => LanguagesWidget(), settings: settings);
      case RouteNamed.HELP:
        return MaterialPageRoute(
            builder: (_) => HelpWidget(), settings: settings);
      case RouteNamed.CONTACT:
        return MaterialPageRoute(
            builder: (context) => ContactWidget.provider(context),
            settings: settings);
      case RouteNamed.CONFRIM_PAYMENT:
        return MaterialPageRoute(
            builder: (_) => ConfrimPaymentWidget(), settings: settings);
      case RouteNamed.NEW:
        return MaterialPageRoute(
            builder: (context) {
              return NewWidget.provider(
                context,
                args as int,
              );
            },
            settings: settings);
      case RouteNamed.TABS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<TabsBloc>(
                create: (BuildContext context) => TabsBloc(),
                child: TabsWidget.provider(context, args),
              );
            },
            settings: settings);
      case RouteNamed.OTP:
        return MaterialPageRoute(
            builder: (context) {
              return OtpWidget.provider(
                  context, args as RequestPhoneNumberResponse);
            },
            settings: settings);
      case RouteNamed.CHANGE_PASS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    ChangePasswordBloc(repository: repository),
                child: ChangePasswordWidget(),
              );
            },
            settings: settings);
      case RouteNamed.SEARCH_ADDRESS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    MapBloc(repository: repository),
                child: SearchAddressScreen(onSelectAddress: args as Function),
              );
            },
            settings: settings);
      case RouteNamed.CREATE_ORDER:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                  create: (BuildContext context) =>
                      CreateOrderBloc(repository: repository),
                  child: CreateOrderWidget.provider(context));
            },
            settings: settings);
      case RouteNamed.NEW_PASS:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) {
              return NewPasswordWidget.provider(context, mapData["token"],
                  mapData["code"], mapData["phonenumber"]);
            },
            settings: settings);
      case RouteNamed.ADDRESS_MAP:
        return MaterialPageRoute(
            builder: (context) {
              return SelectMapWidget.provider(context);
            },
            settings: settings);
      case RouteNamed.DETAIL_NOTIFICATIONS:
        return MaterialPageRoute(
            builder: (_) =>
                DetailNotifications(notification: args as NotificationData),
            settings: settings);

      case RouteNamed.ORDER_TRASH_DETAIL:
        return MaterialPageRoute(
            builder: (_) => OrderTrashDetailWidget(args as OrderModel),
            settings: settings);

      case RouteNamed.ORDERS_DETAIL_CATEGORY:
        return MaterialPageRoute(
            builder: (_) => OrderDetailCategoryWidget(args as OrderModel),
            settings: settings);
      case RouteNamed.CHANGE_PASS:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    ChangePasswordBloc(repository: repository),
                child: ChangePasswordWidget(),
              );
            },
            settings: settings);
      case RouteNamed.BLOG_DETAIL:
        return MaterialPageRoute(
            builder: (_) => BlogNotifications(blogDetail: args as BlogDetail),
            settings: settings);
      case RouteNamed.REVIEW:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (BuildContext context) => CreatePassAccountBloc(),
                child: ReviewWidget(),
              );
            },
            settings: settings);
      case RouteNamed.ORDER_CONFRIM_DETAIL:
        return MaterialPageRoute(
            builder: (context) =>
                OrdersConfrimDetailWidget(orderModel: args as OrderModel),
            settings: settings);

      case RouteNamed.WITHDRAW:
        var mapData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => WithdrawScreen.provider(
                context, mapData['withdrawal'], mapData['phonenumber']),
            settings: settings);

      case RouteNamed.HISTORY_WITHDRAWAL:
        return MaterialPageRoute(
            builder: (context) => HistoryWithdrawalScreen.provider(context),
            settings: settings);

      case RouteNamed.RULE_WITHDRAWAL:
        return MaterialPageRoute(
            builder: (_) => RuleWithdrawalScreen(), settings: settings);

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
