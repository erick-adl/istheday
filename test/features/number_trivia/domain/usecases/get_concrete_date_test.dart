import 'package:dartz/dartz.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:istheday/features/date/domain/repositories/date_repository.interface.dart';
import 'package:istheday/features/date/domain/usecases/get_concrete_date.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDateRepository extends Mock implements IDateRepository {}

void main() {
  GetConcreteDate usecase;
  MockDateRepository mockDateRepository;

  setUp(() {
    mockDateRepository = MockDateRepository();
    usecase = GetConcreteDate(mockDateRepository);
  });

  final tDay = 1;
  final tMonth = 1;
  final tNumberTrivia = Date(text: "test", day: 1, month: 1);

  test(
    'should get date for the day  and month from the repository',
    () async {
      // arrange
      when(mockDateRepository.getDate(any, any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase(Params(day: tDay, month: tMonth));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockDateRepository.getDate(tDay, tMonth));
      verifyNoMoreInteractions(mockDateRepository);
    },
  );
}
