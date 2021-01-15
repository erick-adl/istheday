import 'package:dartz/dartz.dart';
import 'package:istheday/core/usecases/usecase.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:istheday/features/date/domain/repositories/date_repository.interface.dart';
import 'package:istheday/features/date/domain/usecases/get_random_date.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDateRepository extends Mock implements IDateRepository {}

void main() {
  GetRandomDate usecase;
  MockDateRepository mockDateRepository;

  setUp(() {
    mockDateRepository = MockDateRepository();
    usecase = GetRandomDate(mockDateRepository);
  });

  final tNumberTrivia = Date(text: "test", day: 1, month: 1);
  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(mockDateRepository.getRandomDate())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockDateRepository.getRandomDate());
      verifyNoMoreInteractions(mockDateRepository);
    },
  );
}
