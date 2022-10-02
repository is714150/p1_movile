import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_moviles/home/bloc/record_bloc.dart';
import 'package:p1_moviles/home/home_page.dart';
import 'package:p1_moviles/songPreview/bloc/songpreview_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    //poner los bloc necesarios
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecordBloc(),
        ),
        BlocProvider(create: (context) => SongpreviewBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.dark(),
          primaryColor: Colors.purple,
        ),
        title: 'FindTrackApp',
        home: HomePage());
  }
}
