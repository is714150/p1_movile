import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/icon/bg.gif"),
            fit: BoxFit.cover,
          )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: Image(
                  image: AssetImage("assets/icon/record.png"),
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            SizedBox(
              height: 155,
            ),
            //El boton de inicio con Google
            Center(
              child: MaterialButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Iniciar sesión con Google",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  color: Colors.green,
                  minWidth: MediaQuery.of(context).size.width - 30,
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  }),
            ),
          ],
        )
      ]),
    );
  }
}
