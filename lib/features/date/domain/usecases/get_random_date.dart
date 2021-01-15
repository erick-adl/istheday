import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/date.dart';
import '../repositories/date_repository.interface.dart';

class GetRandomDate implements UseCase<Date, NoParams> {
  final IDateRepository repository;

  GetRandomDate(this.repository);

  @override
  Future<Either<Failure, Date>> call(NoParams params) async {
    return await repository.getRandomDate();
  }
}
