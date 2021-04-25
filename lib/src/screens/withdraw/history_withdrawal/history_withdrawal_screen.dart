import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/history_withdrawal/history_withdrawal_bloc.dart';
import 'package:veca_customer/src/bloc/history_withdrawal/history_withdrawal_event.dart';
import 'package:veca_customer/src/bloc/history_withdrawal/history_withdrawal_state.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/momo_history_withdrawal_response.dart';
import 'package:intl/intl.dart';

class HistoryWithdrawalScreen extends StatefulWidget {
  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryWithdrawalBloc(),
      child: HistoryWithdrawalScreen(),
    );
  }

  @override
  _HistoryWithdrawalScreenState createState() =>
      _HistoryWithdrawalScreenState();
}

class _HistoryWithdrawalScreenState extends State<HistoryWithdrawalScreen>
    with UIHelper {
  final numFormat = NumberFormat("#,###");
  HistoryWithdrawalBloc _bloc;
  MomoHistoryWithdrawalResponse momoResponse;

  @override
  void initState() {
    _bloc = BlocProvider.of<HistoryWithdrawalBloc>(context);
    _bloc.add(GetListHistoryWithdrawal());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final _primaryColor = Theme.of(context).primaryColor;
    return BlocListener<HistoryWithdrawalBloc, BaseState>(
      listener: (context, state) {
        handleCommonState(context, state);
        if (state is GetListWithdrawalMomoSuccess) {
          momoResponse = state.response;
        }
        if (state is DeletePayoutSuccessState) {
          showToast(context, 'delete_payout_success');
        }
      },
      child: BlocBuilder<HistoryWithdrawalBloc, BaseState>(
        builder: (context, state) {
          final listHistory = momoResponse?.data ?? [];
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(UiIcons.return_icon,
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
                  localizedText(context, 'history_withdrawal'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .merge(TextStyle(color: _primaryColor)),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SafeArea(
                  child: momoResponse != null
                      ? Container(
                          child: listHistory.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  primary: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: listHistory?.length,
                                  separatorBuilder: (context, index) =>
                                      Container(
                                    height: 4,
                                    color: Colors.white,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item =
                                        listHistory.reversed.elementAt(index);
                                    return _buildListItem(item);
                                  },
                                )
                              : Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.asset(
                                            'assets/icon/logo.png',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        localizedText(context, 'empty_history'),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      : _buildShimmer(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(MomoObject item) {
    Color color = Colors.red;
    IconData icon = Icons.clear;
    if (item.status == 'finished') {
      color = Colors.green;
      icon = Icons.check;
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5),
                ),
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        "img/icon_wallet.png",
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        localizedText(context, 'transfer_to_wallet_momo'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    item.status != 'finished'
                        ? InkWell(
                            onTap: () {
                              if (item.status == 'pending') {
                                showCustomDialog2(
                                    title: localizedText(context, "VECA"),
                                    description: localizedText(
                                        context, 'do_you_want_cancel_payout'),
                                    buttonText: localizedText(context, 'ok'),
                                    buttonClose:
                                        localizedText(context, 'close'),
                                    image: Image.asset('img/icon_warning.png',
                                        color: Colors.white),
                                    context: context,
                                    onPress: () {
                                      hasShowPopUp = false;
                                      Navigator.of(context).pop();
                                      _bloc.add(DeletePayout(item.id));
                                    });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${formatTime(item.createdAt) ?? DateTime.now()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //     '${localizedText(context, 'status')} ${item?.status ?? ''}'),
                    Row(
                      children: [
                        Text(
                          localizedText(context, 'status'),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(width: 2),
                        Text(
                          localizedText(context, item?.status ?? ''),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: item.status == 'pending'
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      ],
                    ),
                    Text(
                      '${numFormat.format((item?.amount ?? 0))} đ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    _bloc.add(GetListHistoryWithdrawal());
    return null;
  }

  String formatTime(int dateint) {
    String date = DateFormat('dd/MM/yyyy - HH:mm')
        .format(new DateTime.fromMillisecondsSinceEpoch(dateint));
    return date;
  }
}
