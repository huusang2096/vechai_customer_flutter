import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/signin/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/login_account_request.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';
import 'package:veca_customer/src/uitls/phone_helper.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();

  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckPhoneBloc(),
      child: SignInWidget(),
    );
  }
}

class _SignInWidgetState extends State<SignInWidget> with UIHelper {
  final _phoneController = TextEditingController();
  ProgressDialog pr;
  Country _selected = Country(
      asset: "assets/flags/vn_flag.png",
      dialingCode: "84",
      isoCode: "VN",
      currency: "VND",
      currencyISO: "VND");
  CheckPhoneBloc _bloc;
  RequestPhoneNumberResponse requestPhoneNumberResponse;

  @override
  void initState() {
    _bloc = BlocProvider.of<CheckPhoneBloc>(context);
    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _onSignInButtonPressed() async {

      if(_phoneController.text.isEmpty){
        showToast(context, localizedText(context,'not_a_valid_phone_number'));
        return;
      }
      final phoneModel = await PhoneHelper.parsePhone(_phoneController.text.toString(),_selected.isoCode);

      if(phoneModel == null){
        showToast(context, localizedText(context, 'valid_phone_number'));
        return;
      }

      requestPhoneNumberResponse = new RequestPhoneNumberResponse();
      requestPhoneNumberResponse.phoneCountryCode = "+"+_selected.dialingCode;
      requestPhoneNumberResponse.phoneNumber = phoneModel.national_number;
      requestPhoneNumberResponse.iSOCode = _selected.isoCode;

      _bloc.add(CheckPhoneEvent(requestPhoneNumberResponse));
    }

    return BlocListener<CheckPhoneBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if(state is OpenLoginState){
       Navigator.of(context)
           .pushNamed(RouteNamed.INPUT_PASS, arguments: state.loginAccountRequest);
     }

     if(state is OpenOTPState){
       Navigator.of(context)
           .pushNamed(RouteNamed.OTP, arguments: requestPhoneNumberResponse);
     }
    }, child: BlocBuilder<CheckPhoneBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(children: <Widget>[
              Container(height: MediaQuery.of(context).size.height/2, width: double.infinity,
                  decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
              Container(
                height: 300,
                margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context)
                            .hintColor
                            .withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 15)
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(  localizedText(context, 'login_with_phone_number'),
                        style: Theme.of(context).textTheme.headline3),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).hintColor, //                   <--- border color
                            width: 1.0,
                          ),
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 0,
                              child: CountryPicker(
                                showDialingCode: true,
                                dense: false,
                                showFlag: false,
                                //displays flag, true by default
                                showName: false,
                                //displays country name, true by default
                                showCurrency: false,
                                //eg. 'British pound'
                                showCurrencyISO: false,
                                onChanged: (Country country) {
                                  setState(() {
                                    _selected = country;
                                  });
                                },
                                selectedCountry: _selected,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .tr('input_phone_number'),
                                  //S.of(context).email_addr,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(
                                    TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                controller: _phoneController,
                              ),
                            )
                          ],
                        ),),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _onSignInButtonPressed,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: getLinearGradient(),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(localizedText(context, 'login'),textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])),
      );
    }));
  }
}
