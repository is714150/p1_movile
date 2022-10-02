import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_moviles/songPreview/bloc/songpreview_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SongPreview extends StatefulWidget {
  final Map<String, dynamic> songInfo;

  SongPreview({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<SongPreview> createState() => _SongPreviewState();
}

class _SongPreviewState extends State<SongPreview> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongpreviewBloc, SongpreviewState>(
      listener: (context, state) {
        if (state is SongpreviewSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Agregando a favoritos...",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ));
        } else if (state is SongpreviewErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Ya existe la cancion en favoritos..."),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Here you go"),
              actions: [
                IconButton(
                    onPressed: () {
                      //Agregar cancion a lista de favoritos de usuario
                      //Usar bloc de SongPreview
                      showDialog(
                          context: context,
                          builder: (builder) => AlertDialog(
                                title: Text("Agregar a favoritos"),
                                content: Text(
                                    "El elemento será agregado a tus favoritos"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancelar")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        BlocProvider.of<SongpreviewBloc>(
                                                context)
                                            .add(OnAddSongToFavorites(
                                                infoAboutSong:
                                                    widget.songInfo));
                                      },
                                      child: Text("Continuar"))
                                ],
                              ));
                    },
                    icon: Icon(Icons.favorite))
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                      Image.network(widget.songInfo["albumImage"].toString()),
                ),
                Text(
                  widget.songInfo["title"].toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.songInfo["album"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.songInfo["artist"].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.songInfo["release_date"].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Abrir con"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        launchUrlString(widget.songInfo["spotify"].toString());
                      },
                      child: Tooltip(
                        message: "Abrir con Spotify",
                        child: Image.asset(
                          "assets/icon/spotify.png",
                          height: 64,
                          width: 64,
                        ),
                      ),
                    ),
                    MaterialButton(
                        onPressed: () {
                          launchUrlString(
                              widget.songInfo["song_link"].toString());
                        },
                        child: Tooltip(
                          message: "Abrir con Linktree",
                          child: Image.asset(
                            "assets/icon/linktree.png",
                            height: 64,
                            width: 64,
                          ),
                        )),
                    MaterialButton(
                      onPressed: () {
                        if (widget.songInfo["apple_music"] != null) {
                          launchUrlString(
                              widget.songInfo["apple_music"]["url"].toString());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("No se encuentra la cancion"),
                          ));
                        }
                      },
                      child: Tooltip(
                        message: "Abrir con Apple Music",
                        child: Image.asset(
                          "assets/icon/apple.png",
                          height: 64,
                          width: 64,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
      },
    );
  }
}
