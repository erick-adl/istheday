import 'dart:convert';

import 'package:istheday/core/error/exceptions.dart';
import 'package:istheday/features/date/data/models/date_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IDateLocalDataSource {
  /// Gets the cached [DateModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<DateModel> getLastDate();

  Future<void> cacheDate(DateModel dateToCache);
}

const CACHED_DATE_TRIVIA = 'CACHED_DATE_TRIVIA';

class DateLocalDataSource implements IDateLocalDataSource {
  final SharedPreferences sharedPreferences;

  DateLocalDataSource({@required this.sharedPreferences});

  @override
  Future<DateModel> getLastDate() {
    final jsonString = sharedPreferences.getString(CACHED_DATE_TRIVIA);
    if (jsonString != null) {
      return Future.value(DateModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDate(DateModel dateToCache) {
    return sharedPreferences.setString(
      CACHED_DATE_TRIVIA,
      json.encode(dateToCache.toJson()),
    );
  }
}
