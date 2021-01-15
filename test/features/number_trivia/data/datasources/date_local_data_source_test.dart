import 'dart:convert';

import 'package:istheday/core/error/exceptions.dart';
import 'package:istheday/features/date/data/datasources/date_local_data_source.dart';
import 'package:istheday/features/date/data/models/date_model.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  IDateLocalDataSource dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = DateLocalDataSource(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastDate', () {
    final tDateModel =
        DateModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return Date from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastDate();
        // assert
        verify(mockSharedPreferences.getString(CACHED_DATE_TRIVIA));
        expect(result, equals(tDateModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastDate;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheDate', () {
    final tDateModel = DateModel(day: 1, month: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheDate(tDateModel);
        // assert
        final expectedJsonString = json.encode(tDateModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_DATE_TRIVIA,
          expectedJsonString,
        ));
      },
    );
  });
}
