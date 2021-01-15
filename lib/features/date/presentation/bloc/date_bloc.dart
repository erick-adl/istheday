import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:istheday/core/error/failures.dart';
import 'package:istheday/core/usecases/usecase.dart';

import 'package:dartz/dartz.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_date.dart';
import '../../domain/usecases/get_random_date.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class DateBloc extends Bloc<DateEvent, DateState> {
  final GetConcreteDate getConcreteDate;
  final GetRandomDate getRandomDate;
  final InputConverter inputConverter;

  DateBloc({
    @required GetConcreteDate concrete,
    @required GetRandomDate random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteDate = concrete,
        getRandomDate = random;

  @override
  DateState get initialState => Empty();

  @override
  Stream<DateState> mapEventToState(
    DateEvent event,
  ) async* {
    if (event is GetDateForConcreteDay) {
      final inputEitherDay =
          inputConverter.stringToUnsignedInteger(event.dayString);
      final inputEitherMonth =
          inputConverter.stringToUnsignedInteger(event.monthString);

      if (inputEitherDay.isLeft() || inputEitherMonth.isLeft()) {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      } else {
        yield Loading();
        final failureOrTrivia = await getConcreteDate(Params(
            day: inputEitherDay.getOrElse(null),
            month: inputEitherMonth.getOrElse(null)));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      }
    } else if (event is GetDateForRandomDay) {
      yield Loading();
      final failureOrTrivia = await getRandomDate(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<DateState> _eitherLoadedOrErrorState(
    Either<Failure, Date> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (date) => Loaded(date: date),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
