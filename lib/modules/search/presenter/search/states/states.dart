import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';

abstract class SearchState {}

class SearchSuccess implements SearchState {
  final List<ResultSearch> list;
  SearchSuccess(this.list);
}

class SearchFailure implements SearchState {
  final FailureSearch error;

  SearchFailure(this.error);
}

class SearchLoading implements SearchState {}

class SearchStart implements SearchState {}
