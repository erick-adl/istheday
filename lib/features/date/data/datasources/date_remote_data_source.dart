import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../models/date_model.dart';

abstract class IDateRemoteDataSource {
  /// Calls the http://numbersapi.com/{day}/{month} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<DateModel> getConcreteDate(int day, int month);

  /// Calls the http://numbersapi.com/random/date endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<DateModel> getRandomDate();
}

class DateRemoteDataSource implements IDateRemoteDataSource {
  final http.Client client;

  DateRemoteDataSource({@required this.client});

  @override
  Future<DateModel> getConcreteDate(int day, int month) =>
      _getTriviaFromUrl('http://numbersapi.com/$month/$day');

  @override
  Future<DateModel> getRandomDate() =>
      _getTriviaFromUrl('http://numbersapi.com/random/date');

  Future<DateModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return DateModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
