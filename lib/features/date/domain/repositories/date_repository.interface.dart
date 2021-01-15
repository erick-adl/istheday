import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/date.dart';

abstract class IDateRepository {
  Future<Either<Failure, Date>> getDate(int day, int month);
  Future<Either<Failure, Date>> getRandomDate();
}
