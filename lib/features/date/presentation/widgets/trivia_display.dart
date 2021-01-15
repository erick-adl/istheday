import 'package:istheday/features/date/domain/entities/date.dart';

import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final Date date;

  const TriviaDisplay({
    Key key,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  date.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
