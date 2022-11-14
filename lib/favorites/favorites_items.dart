import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_moviles/favorites/bloc/favorites_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesItem extends StatefulWidget {
  //Informacion de las canciones
  final Map<String, dynamic> songInfo;

  FavoritesItem({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<FavoritesItem> createState() => _FavoritesItemState();
}

class _FavoritesItemState extends State<FavoritesItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  title: Text("Abrir canción"),
                  content: Text("¿Quiere abrir los links de la canción?"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: Text("No")
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        launch(widget.songInfo["song_link"]);
                      }, 
                      child: Text("Si")
                    ),
                  ],
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(25.0)
                ),
                child: Image.network(widget.songInfo["albumImage"]),
                  
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width - 300,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.8),
                  ),
                  child: Column(
                    children: [
                      Text(widget.songInfo["title"], style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                      Text(widget.songInfo["artist"], style: TextStyle(color: Colors.white60, fontSize: 15),),
                    ],
                  ),      
                ),
              ),
            ),
            IconButton(
              onPressed: (){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  title: Text("Eliminar de favoritos"),
                  content: Text("El elemento será eliminado de tus favoritos. ¿Quieres continuar?"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: Text("Cancelar")
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        BlocProvider.of<FavoritesBloc>(context).add(OnRemoveSong(toRemoveSongInfo: widget.songInfo));
                        BlocProvider.of<FavoritesBloc>(context).add(OnGetFavorites());
                      }, 
                      child: Text("Eliminar")
                    ),
                  ],
                ));
              }, 
              icon: Icon(Icons.favorite), 
              color: Colors.red[900], 
              iconSize: 40.0
            ),
          ],
        ),
      ),
    );
  }
}