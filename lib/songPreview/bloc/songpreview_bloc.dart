import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
part 'songpreview_event.dart';
part 'songpreview_state.dart';

class SongpreviewBloc extends Bloc<SongpreviewEvent, SongpreviewState> {
  SongpreviewBloc() : super(SongpreviewInitial()) {
    on<OnAddSongToFavorites>(_saveData);
  }

  FutureOr<void> _saveData(OnAddSongToFavorites event, Emitter emit) async {
    emit(SongprevieUploadingState());
    bool _saved = await _saveFavoriteSong(event.infoAboutSong);

    if(_saved) {
      emit(SongpreviewSuccessState());
    } else {
      emit(SongpreviewErrorState());
    }
  }

  FutureOr<bool> _saveFavoriteSong(Map<String, dynamic> infoSong) async {
    //Obtener la informacion de la cancion
    Map<String, dynamic> requiredSongInfo = {
      "title": infoSong["title"].toString(),
      "albumImage": infoSong["albumImage"].toString(),
      "artist": infoSong["artist"].toString(),
      "song_link": infoSong["song_link"].toString()
    };


    try{
      //Obtener el id del usuario
      var User = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser!.uid}");
      
      //Obtener canciones favoritas del usuario
      var docsRef = await User.get();
      List<dynamic> listIds = docsRef.data()?["favoriteSongs"];

      //Revisar si la cancion ya esta en la lista
      for(var song in listIds){
        if(mapEquals(song, requiredSongInfo)){
          return false;
        }
      }

      //Agregar la cancion nueva
      listIds.add(requiredSongInfo);

      await User.update({"favoriteSongs": listIds});
      return true;

    }catch(e){
      print("Error en actualizar el documento: $e");
      return false;
    }
  } 
}
