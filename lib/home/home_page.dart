import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_moviles/favorites/favorites_page.dart';
import 'package:p1_moviles/home/bloc/record_bloc.dart';
import 'package:p1_moviles/login/bloc/auth_bloc.dart';
import 'package:p1_moviles/songPreview/song_preview.dart';

import '../favorites/bloc/favorites_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Animacion del boton
  bool _animate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state is RecordErrorState) {
          setState(() {
            _animate = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error al buscar la cancion")));
        } else if (state is RecordSuccessState) {
          setState(() {
            _animate = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SongPreview(songInfo: state.songInfoJson)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  "Toque para escuchar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: AvatarGlow(
                    glowColor: Colors.blue,
                    endRadius: 120,
                    animate: _animate,
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _animate = true;
                            });
                            BlocProvider.of<RecordBloc>(context)
                                .add(OnListenToSong());
                          },
                          child: Image(
                            image: AssetImage("assets/icon/record.png"),
                          ),
                        ),
                        radius: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<FavoritesBloc>(context).add(OnGetFavorites());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Favorites()
                          )
                        );
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.favorite),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      iconSize: 40,
                      tooltip: "Favoritos",
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (builder) => AlertDialog(
                            title: Text("Cerrar sesión"),
                            content: Text("Al cerrar sesión de su cuenta será redirigido a la pantalla de Log in, ¿Quiere continuar?"),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"), 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Cerrar sesión"), 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  BlocProvider.of<AuthBloc>(context)..add(SignOutEvent());
                                },
                              ),
                            ],
                          ),
                        );
                        
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.power_settings_new),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      iconSize: 40,
                      tooltip: "Salir",
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
