import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_moviles/home/bloc/record_bloc.dart';
import 'package:p1_moviles/home/home_page.dart';
import 'package:p1_moviles/songPreview/bloc/songpreview_bloc.dart';
import 'favorites/bloc/favorites_bloc.dart';
import 'login/bloc/auth_bloc.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    //poner los bloc necesarios
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecordBloc(),
        ),
        BlocProvider(
          create: (context) => SongpreviewBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
        BlocProvider(
            create: (context) => FavoritesBloc()..add(OnGetFavorites())),
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
      home: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error en la autenticación"),
          ));
        }
      }, builder: (context, state) {
        if (state is AuthSuccessState) {
          return HomePage();
        } else if (state is AuthFailState ||
            state is AuthErrorState ||
            state is SignOutSuccessState) {
          return LoginPage();
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.purple),
          );
        }
      }),
    );
  }
}
