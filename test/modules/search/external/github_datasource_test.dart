import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/external/github_datasource.dart';
import 'package:flutter_clean_architecture/modules/utils/github_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioMock extends Mock implements Dio {}

main() {
  final dio = DioMock();
  final datasource = GithubDatasource(dio);

  test('Return a ResultSearchModel list', () async {
    when(dio.get(any)).thenAnswer((_) async => Response(data: jsonDecode(githubResponse), statusCode: 200));

    final result = datasource.getSearch('Flutter');
    expect(result, completes);
  });

  test('Return an error when status code 404', () async {
    when(dio.get(any)).thenAnswer((_) async => Response(data: null, statusCode: 404));

    final result = datasource.getSearch('Flutter');
    expect(result, throwsA(isA<DatasourceError>()));
  });

  test('Return an error when platform error', () async {
    when(dio.get(any)).thenThrow(Exception());

    final result = datasource.getSearch('Flutter');
    expect(result, throwsA(isA<Exception>()));
  });
}
