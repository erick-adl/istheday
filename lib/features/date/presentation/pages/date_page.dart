import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:istheday/features/date/presentation/bloc/bloc.dart';
import 'package:istheday/features/date/presentation/widgets/loading_widget.dart';
import 'package:istheday/features/date/presentation/widgets/message_display.dart';
import 'package:istheday/features/date/presentation/widgets/trivia_controls.dart';
import 'package:istheday/features/date/presentation/widgets/trivia_display.dart';

import '../../../../injection_container.dart';

class DatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Is The Day'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<DateBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DateBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<DateBloc, DateState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(date: state.date);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              DateControls()
            ],
          ),
        ),
      ),
    );
  }
}
