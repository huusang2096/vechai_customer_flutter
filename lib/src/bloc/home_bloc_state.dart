import 'package:meta/meta.dart';
import 'package:veca_customer/src/models/ScrapDetailResponse.dart';
import 'package:veca_customer/src/models/ScrapResponse.dart';

import 'base_state.dart';

class InitialHomeBlocState extends BaseState {}

class GetListScrapSuccessState extends BaseState {
 List<ScrapModel> scraps;

  GetListScrapSuccessState(this.scraps);
}

class GetScrapDetailSuccessState extends BaseState {
 ScrapDetailResponse  scrapDetailResponse;

 GetScrapDetailSuccessState(this.scrapDetailResponse);
}