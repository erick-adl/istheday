import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Date extends Equatable {
  final String text;
  final int day;
  final int month;

  Date({
    @required this.text,
    @required this.day,
    @required this.month,
  });

  @override
  List<Object> get props => [text, day, month];
}
