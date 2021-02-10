import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/domain/usecases/search_by_text.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/search_bloc.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/states/states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SearchByTextMock extends Mock implements SearchByText {}

main() {
  final usecase = SearchByTextMock();
  final bloc = SearchBloc(usecase);

  test('Return states correct order', () async {
    when(usecase.call(any)).thenAnswer((_) async => Right(<ResultSearch>[]));

    expect(
      bloc,
      emitsInOrder(
        [
          isA<SearchLoading>(),
          isA<SearchSuccess>(),
        ],
      ),
    );

    bloc.add('Texts');
  });

  test('Return error', () async {
    when(usecase.call(any)).thenAnswer((_) async => Left(InvalidTextError()));

    expect(
      bloc,
      emitsInOrder(
        [
          isA<SearchLoading>(),
          isA<SearchFailure>(),
        ],
      ),
    );

    bloc.add('Texts');
  });
}
