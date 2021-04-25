import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/withdraw/withdraw_bloc.dart';
import 'package:veca_customer/src/bloc/withdraw/withdraw_event.dart';
import 'package:veca_customer/src/bloc/withdraw/withdraw_state.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/momo_denominations_response.dart';
import 'package:veca_customer/src/widgets/ToastWidget.dart';
import 'package:intl/intl.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({Key key, this.withdrawal, this.phoneNumber})
      : super(key: key);

  static provider(BuildContext context, String withdrawal, String phoneNumber) {
    return BlocProvider(
      create: (context) => WithdrawBloc(),
      child: WithdrawScreen(withdrawal: withdrawal, phoneNumber: phoneNumber),
    );
  }

  String withdrawal;
  String phoneNumber;

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> with UIHelper {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final numFormat = NumberFormat("#,###");
  WithdrawBloc _bloc;
  MomoDenominationsResponse momoDenominationsResponse;
  int indexDenomination = -1;
  bool isChangeSuffixIcon = true;

  @override
  void initState() {
    _bloc = BlocProvider.of<WithdrawBloc>(context);
    _bloc.add(CheckShowInstalMoMoEvent());
    _bloc.add(GetDenominations());
    super.initState();
  }

  _launchURL() async {
    const url = 'https://momoapp.page.link/vc5c5HXpT3uc6xMA8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final _primaryColor = Theme.of(context).primaryColor;
    return BlocListener<WithdrawBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if (state is ISShowMOMOState) {
          if (!state.isShow) {
            Navigator.of(context).pushNamed(RouteNamed.RULE_WITHDRAWAL);
          }
        }
        if (state is WithdrawSuccessState) {
          _textEditingController.text = '';
          widget.withdrawal = state.price;
          showCustomDialog2(
              title: localizedText(context, "VECA"),
              description: localizedText(context, state.message),
              buttonText: localizedText(context, 'open_momo'),
              buttonClose: localizedText(context, 'close'),
              image: Image.asset('img/icon_success.png', color: Colors.white),
              context: context,
              onPress: () {
                _launchURL();
              });
        }
        if (state is GetListDenominationSuccess) {
          momoDenominationsResponse = state.response;
        }
        if (state is SelectDenominationState) {
          indexDenomination = state.id;
        }
        if (state is ChangeSuffixIconState) {
          isChangeSuffixIcon = state.changeSuffixIcon;
        }
      },
      child: BlocBuilder<WithdrawBloc, BaseState>(
        builder: (context, state) {
          final listPrice = momoDenominationsResponse?.data ?? [];
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(UiIcons.return_icon,
                      color: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: getLinearGradient())),
                elevation: 0,
                bottomOpacity: 0,
                iconTheme: IconThemeData(color: _primaryColor),
                title: Text(
                  localizedText(context, 'withdrawal'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: _primaryColor)),
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 20,
                                      offset: Offset.zero,
                                      color: Colors.grey.withOpacity(0.5),
                                    )
                                  ],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                'assets/icon/logo.png',
                                                width: 50,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                  localizedText(
                                                      context, 'balance'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                              Text(' : '),
                                              Expanded(
                                                child: AutoSizeText(
                                                    '${widget?.withdrawal ?? 0}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.end,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ),
                                              SizedBox(width: 5),
                                              Text('đ',
                                                  textAlign: TextAlign.end,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        Container(
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _textEditingController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              NumericTextFormatter()
                                            ],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            onChanged: (value) {
                                              _bloc.add(TextChange(value));
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  gapPadding: 5.0),
                                              hintText: '0 đ',
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: Colors.grey),
                                              labelText: localizedText(
                                                  context, 'amount'),
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .merge(TextStyle(
                                                      fontSize: 16.0)),
                                              contentPadding:
                                                  EdgeInsets.all(15.0),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  gapPadding: 5.0),
                                              suffixIcon: !isChangeSuffixIcon
                                                  ? IconButton(
                                                      onPressed: () {
                                                        _bloc.add(
                                                            SelectDenomination(
                                                                -1));
                                                        _textEditingController
                                                            .clear();
                                                      },
                                                      icon: Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                            ),
                                            validator: (value) {
                                              return validate(value);
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.security,
                                              size: 20,
                                              color: Colors.greenAccent,
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  localizedText(context,
                                                      'rule_withdrawal'),
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(RouteNamed
                                                            .RULE_WITHDRAWAL);
                                                  },
                                                  child: Text(
                                                      localizedText(
                                                          context, 'read_more'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: listPrice.isNotEmpty
                                    ? Container(
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 6,
                                            crossAxisSpacing: 6,
                                            childAspectRatio: 2,
                                          ),
                                          primary: true,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: listPrice.length,
                                          itemBuilder: (context, index) {
                                            final item =
                                                listPrice.elementAt(index);
                                            final currency = numFormat
                                                .format(item?.amount ?? 0);
                                            return GestureDetector(
                                              onTap: () {
                                                _textEditingController.text =
                                                    numFormat.format(
                                                        item?.amount ?? 0);
                                                _textEditingController
                                                        .selection =
                                                    TextSelection.fromPosition(
                                                        TextPosition(
                                                            offset:
                                                                _textEditingController
                                                                    .text
                                                                    .length));
                                                _bloc.add(
                                                    SelectDenomination(index));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color:
                                                            indexDenomination ==
                                                                    index
                                                                ? Colors.green
                                                                : Colors.grey),
                                                    color: indexDenomination ==
                                                            index
                                                        ? Colors.green
                                                            .withOpacity(0.2)
                                                        : Colors.transparent),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: AutoSizeText(
                                                        '$currency đ',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    indexDenomination == index
                                                        ? Positioned(
                                                            top: 5,
                                                            right: 5,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.4)),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : _buildShimmer(),
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      localizedText(context, 'recive_method')
                                          .toUpperCase(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          'img/momo_icon.png',
                                          width: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            localizedText(
                                                context, 'momo_account'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        Expanded(
                                          flex: 1,
                                          child: Text(widget.phoneNumber,
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'img/insurance.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            localizedText(
                                                context, 'momo_information'),
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _onWithdrawButtonPressed();
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: getLinearGradientButton(),
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
                              child: Text(localizedText(context, 'withdrawal'),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .merge(TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String validate(var value) {
    if (value.isEmpty) {
      return localizedText(context, 'not_a_valid_withdraw');
    }
    double price =
        double.parse(_textEditingController.text.replaceAll(',', ''));
    double pay = price + (price * 0.1);
    double sum = double.parse(widget.withdrawal.replaceAll(',', ''));
    print("PRICE" + pay.toString());

    if (pay >= sum) {
      return localizedText(context, 'not_enough_money');
    }
    if (price <= 10000) {
      return localizedText(context, 'min_withdraw');
    }
    return null;
  }

  void _onWithdrawButtonPressed() async {
    if (_formKey.currentState.validate()) {
      _bloc.add(Withdraw(
          int.parse(_textEditingController.text.replaceAll(',', '')),
          widget.phoneNumber));
    }
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2,
          ),
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
  void dispose() {
    _bloc.close();
    _textEditingController.dispose();
    super.dispose();
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat('#,###');
      if (int.tryParse(newValue.text.replaceAll(f.symbols.GROUP_SEP, '')) ==
          null) {
        return oldValue;
      }
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));

      final newString = f.format(number) + "";
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
