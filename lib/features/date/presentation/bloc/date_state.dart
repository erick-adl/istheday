import 'package:equatable/equatable.dart';
import 'package:istheday/features/date/domain/entities/date.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DateState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends DateState {}

class Loading extends DateState {}

class Loaded extends DateState {
  final Date date;

  Loaded({@required this.date});

  @override
  List<Object> get props => [date];
}

class Error extends DateState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
