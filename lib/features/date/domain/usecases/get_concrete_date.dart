import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/date.dart';
import '../repositories/date_repository.interface.dart';

class GetConcreteDate implements UseCase<Date, Params> {
  final IDateRepository repository;

  GetConcreteDate(this.repository);

  @override
  Future<Either<Failure, Date>> call(Params params) async {
    return await repository.getDate(params.day, params.month);
  }
}

class Params extends Equatable {
  final int day;
  final int month;

  Params({@required this.day, @required this.month});

  @override
  List<Object> get props => [day, month];
}
