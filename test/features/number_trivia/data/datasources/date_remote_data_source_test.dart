import 'dart:convert';

import 'package:istheday/core/error/exceptions.dart';
import 'package:istheday/features/date/data/datasources/date_remote_data_source.dart';
import 'package:istheday/features/date/data/models/date_model.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  DateRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = DateRemoteDataSource(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteDate', () {
    final tDay = 1;
    final tMonth = 1;
    final tDateModel = DateModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteDate(tDay, tMonth);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tDay/$tMonth',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Date when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteDate(tDay, tMonth);
        // assert
        expect(result, equals(tDateModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteDate;
        // assert
        expect(
            () => call(tDay, tMonth), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomDate', () {
    final tDateModel = DateModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomDate();
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random/date',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Date when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomDate();
        // assert
        expect(result, equals(tDateModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomDate;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
