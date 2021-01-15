import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:istheday/features/date/presentation/bloc/bloc.dart';

class DateControls extends StatefulWidget {
  const DateControls({
    Key key,
  }) : super(key: key);

  @override
  _DateControlsState createState() => _DateControlsState();
}

class _DateControlsState extends State<DateControls> {
  final controllerDay = TextEditingController();
  final controllerMonth = TextEditingController();
  String inputStrDay;
  String inputStrMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controllerDay,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a day',
          ),
          onChanged: (value) {
            inputStrDay = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        TextField(
          controller: controllerMonth,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a month',
          ),
          onChanged: (value) {
            inputStrMonth = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                child: Text('Get random date'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controllerDay.clear();
    controllerMonth.clear();
    BlocProvider.of<DateBloc>(context)
        .add(GetDateForConcreteDay(inputStrDay, inputStrMonth));
  }

  void dispatchRandom() {
    controllerDay.clear();
    controllerMonth.clear();
    BlocProvider.of<DateBloc>(context).add(GetDateForRandomDay());
  }
}
