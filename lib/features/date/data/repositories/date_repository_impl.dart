import 'package:dartz/dartz.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/repositories/date_repository.interface.dart';
import '../datasources/date_local_data_source.dart';
import '../datasources/date_remote_data_source.dart';

typedef Future<Date> _ConcreteOrRandomChooser();

class DateRepository implements IDateRepository {
  final IDateRemoteDataSource remoteDataSource;
  final IDateLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DateRepository({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Date>> getDate(
    int day,
    int month,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteDate(day, month);
    });
  }

  @override
  Future<Either<Failure, Date>> getRandomDate() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomDate();
    });
  }

  Future<Either<Failure, Date>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheDate(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastDate();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
