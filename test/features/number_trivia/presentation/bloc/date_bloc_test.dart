import 'package:istheday/core/error/failures.dart';
import 'package:istheday/core/usecases/usecase.dart';
import 'package:istheday/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:istheday/features/date/domain/usecases/get_concrete_date.dart';
import 'package:istheday/features/date/domain/usecases/get_random_date.dart';
import 'package:istheday/features/date/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteDate extends Mock implements GetConcreteDate {}

class MockGetRandomDate extends Mock implements GetRandomDate {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  DateBloc bloc;
  MockGetConcreteDate mockGetConcreteDate;
  MockGetRandomDate mockGetRandomDate;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteDate = MockGetConcreteDate();
    mockGetRandomDate = MockGetRandomDate();
    mockInputConverter = MockInputConverter();

    bloc = DateBloc(
      concrete: mockGetConcreteDate,
      random: mockGetRandomDate,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetMonthForConcreteDay', () {
    final tDayString = '1';
    final tDayParsed = 1;
    final tMonthString = '1';
    final tMonthParsed = 1;
    final tDate = Date(day: 1, month: 1, text: 'test date');

    void setUpMockInputDayConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tDayParsed));
    void setUpMockInputMonthConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tMonthParsed));

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForConcreteDay(tDayString, tMonthString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputDayConverterSuccess();
        setUpMockInputMonthConverterSuccess();
        when(mockGetConcreteDate(any)).thenAnswer((_) async => Right(tDate));
        // act
        bloc.add(GetDateForConcreteDay(tDayString, tMonthString));
        await untilCalled(mockGetConcreteDate(any));
        // assert
        verify(
            mockGetConcreteDate(Params(day: tDayParsed, month: tMonthParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputDayConverterSuccess();
        setUpMockInputMonthConverterSuccess();
        when(mockGetConcreteDate(any)).thenAnswer((_) async => Right(tDate));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(date: tDate),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForConcreteDay(tDayString, tMonthString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputDayConverterSuccess();
        setUpMockInputMonthConverterSuccess();
        when(mockGetConcreteDate(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForConcreteDay(tDayString, tMonthString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputDayConverterSuccess();
        setUpMockInputMonthConverterSuccess();
        when(mockGetConcreteDate(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForConcreteDay(tDayString, tMonthString));
      },
    );
  });

  group('GetMonthForRandomNumber', () {
    final tDate = Date(day: 1, month: 1, text: 'test date');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomDate(any)).thenAnswer((_) async => Right(tDate));
        // act
        bloc.add(GetDateForRandomDay());
        await untilCalled(mockGetRandomDate(any));
        // assert
        verify(mockGetRandomDate(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomDate(any)).thenAnswer((_) async => Right(tDate));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(date: tDate),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForRandomDay());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomDate(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForRandomDay());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomDate(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDateForRandomDay());
      },
    );
  });
}
