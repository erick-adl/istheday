import 'package:istheday/core/error/exceptions.dart';
import 'package:istheday/core/error/failures.dart';
import 'package:istheday/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:istheday/features/date/data/datasources/date_local_data_source.dart';
import 'package:istheday/features/date/data/datasources/date_remote_data_source.dart';
import 'package:istheday/features/date/data/models/date_model.dart';
import 'package:istheday/features/date/data/repositories/date_repository_impl.dart';

import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements IDateRemoteDataSource {}

class MockLocalDataSource extends Mock implements IDateLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  DateRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DateRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteDate', () {
    final tDay = 1;
    final tMonth = 1;
    final tDateModel = DateModel(day: tDay, month: tMonth, text: 'test date');
    final Date tDate = tDateModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getDate(tDay, tMonth);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteDate(any, any))
              .thenAnswer((_) async => tDateModel);
          // act
          final result = await repository.getDate(tDay, tMonth);
          // assert
          verify(mockRemoteDataSource.getConcreteDate(tDay, tMonth));
          expect(result, equals(Right(tDate)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteDate(any, any))
              .thenAnswer((_) async => tDateModel);
          // act
          await repository.getDate(tDay, tMonth);
          // assert
          verify(mockRemoteDataSource.getConcreteDate(tDay, tMonth));
          verify(mockLocalDataSource.cacheDate(tDateModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteDate(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getDate(tDay, tMonth);
          // assert
          verify(mockRemoteDataSource.getConcreteDate(tDay, tMonth));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDate())
              .thenAnswer((_) async => tDateModel);
          // act
          final result = await repository.getDate(tDay, tMonth);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDate());
          expect(result, equals(Right(tDate)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDate()).thenThrow(CacheException());
          // act
          final result = await repository.getDate(tDay, tMonth);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDate());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomDate', () {
    final tDateModel = DateModel(day: 1, month: 1, text: 'test date');
    final Date tDate = tDateModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomDate();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomDate())
              .thenAnswer((_) async => tDateModel);
          // act
          final result = await repository.getRandomDate();
          // assert
          verify(mockRemoteDataSource.getRandomDate());
          expect(result, equals(Right(tDate)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomDate())
              .thenAnswer((_) async => tDateModel);
          // act
          await repository.getRandomDate();
          // assert
          verify(mockRemoteDataSource.getRandomDate());
          verify(mockLocalDataSource.cacheDate(tDateModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomDate())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomDate();
          // assert
          verify(mockRemoteDataSource.getRandomDate());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDate())
              .thenAnswer((_) async => tDateModel);
          // act
          final result = await repository.getRandomDate();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDate());
          expect(result, equals(Right(tDate)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDate()).thenThrow(CacheException());
          // act
          final result = await repository.getRandomDate();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDate());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
