import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:meta/meta.dart';

class DateModel extends Date {
  DateModel({
    @required String text,
    @required int day,
    @required int month,
  }) : super(text: text, day: day, month: month);

  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      text: json['text'],
      day: null,
      month: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'day': day,
      'month': month,
    };
  }
}
