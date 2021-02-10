import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/infra/datasources/search_datasource.dart';
import 'package:flutter_clean_architecture/modules/search/infra/models/result_search_model.dart';
import 'package:flutter_clean_architecture/modules/search/infra/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SearchDatasourceMock extends Mock implements SearchDatasource {}

main() {
  final datasource = SearchDatasourceMock();
  final repository = SearchRepositoryImpl(datasource);

  test('Return a ResultSearch list', () async {
    when(datasource.getSearch(any)).thenAnswer((_) async => <ResultSearchModel>[]);

    final result = await repository.search('Flutter');
    expect(result | null, isA<List<ResultSearch>>());
  });

  test('Return an error when datasource fails', () async {
    when(datasource.getSearch(any)).thenThrow(Exception());

    final result = await repository.search('Flutter');
    expect(result.isLeft(), true);
  });
}
