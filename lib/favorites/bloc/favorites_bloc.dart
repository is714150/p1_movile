import 'dart:async';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<OnGetFavorites>(_getFavoriteSongs);
    on<OnRemoveSong>(_removeSong);
  }

  FutureOr<void> _getFavoriteSongs(OnGetFavorites event, Emitter emit) async {
    emit(FavoritesLoadingState());
    try {
      //Usuario
      var user = await FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      //Coleccion de favoritos
      var docsRefs = await user.get();
      List<dynamic> listIds = docsRefs.data()?["favoriteSongs"] ?? [];

      //Mandar la informacion
      emit(FavoritesSuccessState(userFavoritesSongs: listIds));
    } catch (e) {
      print("Error al obtener las canciones: $e");
      emit(FavoritesErrorState());
    }
  }

  FutureOr<void> _removeSong(OnRemoveSong event, Emitter emit) async {
    try {
      //guardar info
      Map<String, dynamic> requiredSongInfo = {
        "title": event.toRemoveSongInfo["title"].toString(),
        "albumImage": event.toRemoveSongInfo["albumImage"].toString(),
        "artist": event.toRemoveSongInfo["artist"].toString(),
        "song_link": event.toRemoveSongInfo["song_link"].toString()
      };

      var user = await FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      List<dynamic> userFavorites = user.data()?["favoriteSongs"];

      //Revisar si la cancion ya esta en la lista
      for (var song in userFavorites) {
        if (mapEquals(song, requiredSongInfo)) {

          FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}").update({
            "favoriteSongs":
            FieldValue.arrayRemove([song]),
          });

          FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}").update({
          });
        }
      }

      emit(FavoritesRemoveSuccessState());
    } catch (e) {
      print("Error al intentar borrar la cancion: $e");
      return;
    }
  }
}
