import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:metri_clock/bloc/clock_bloc.dart';
import 'package:metri_clock/widgets/clock.dart';
import 'package:provider/provider.dart';

/// ClockProviders ensures both ClockModel and ClockBloc are accessible anywhere
/// down the widget tree.
class ClockProviders extends StatelessWidget {
  final ClockModel clockModel;
  final clockBloc = ClockBloc();

  ClockProviders(this.clockModel);

  @override
  Widget build(BuildContext context) {
    print('');
    return MultiProvider(
      providers: [
        Provider<ClockBloc>(
          create: (_) => clockBloc,
          dispose: (_, bloc) => bloc.dispose(),
        ),
        ChangeNotifierProvider<ClockModel>.value(
          value: clockModel,
        ),
        Provider<GlobalKey>(
          create: (_) => GlobalKey(),
        ),
      ],
      child: Clock(),
    );
  }
}
