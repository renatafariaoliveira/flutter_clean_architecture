import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';

import 'package:flutter_clean_architecture/modules/search/infra/datasources/search_datasource.dart';
import 'package:flutter_clean_architecture/modules/search/infra/models/result_search_model.dart';

extension on String {
  normalize() {
    return this.replaceAll(' ', '+');
  }
}

class GithubDatasource implements SearchDatasource {
  final Dio dio;
  GithubDatasource(this.dio);

  @override
  Future<List<ResultSearchModel>> getSearch(String searchText) async {
    final result = await dio.get('https://api.github.com/search/users?q=${searchText.normalize()}');

    if (result.statusCode == 200) {
      var _list = (result.data['items'] as List).map((e) => ResultSearchModel.fromMap(e)).toList();
      return _list;
    } else {
      throw DatasourceError();
    }
  }
}
