import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/BlogDetailResponse.dart';
import 'package:veca_customer/src/models/BlogResponse.dart';

class InitialNewState extends BaseState {}

class ListNewSuccessState extends BaseState {
  List<BlogModel> blogModels;

  ListNewSuccessState(this.blogModels);
}

class BlogDetailSuccessState extends BaseState {
  BlogDetailResponse blogDetailModels;

  BlogDetailSuccessState(this.blogDetailModels);
}