import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDateForConcreteDay extends DateEvent {
  final String dayString;
  final String monthString;

  GetDateForConcreteDay(this.dayString, this.monthString);

  @override
  List<Object> get props => [dayString, monthString];
}

class GetDateForRandomDay extends DateEvent {}
