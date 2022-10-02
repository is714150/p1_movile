import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

part 'songpreview_event.dart';
part 'songpreview_state.dart';

class SongpreviewBloc extends Bloc<SongpreviewEvent, SongpreviewState> {
  SongpreviewBloc() : super(SongpreviewInitial()) {
    on<OnAddSongToFavorites>(_saveData);
  }

  FutureOr<void> _saveData(OnAddSongToFavorites event, Emitter emit) async {
    //Mandar emit para el snackBar
    emit(SongprevieUploadingState());
    bool _saved = await _saveFavoriteSong(event.infoAboutSong);

    if (_saved) {
      emit(SongpreviewSuccessState());
    } else {
      emit(SongpreviewErrorState());
    }
  }

  FutureOr<bool> _saveFavoriteSong(Map<String, dynamic> inforAbotSong) async {
    //Obtener la informacion necesaria
    Map<String, dynamic> requiredSongInfo = {
      "title": inforAbotSong["title"].toString(),
      "albumImage": inforAbotSong["albumImage"].toString(),
      "artist": inforAbotSong["artist"].toString(),
      "song_link": inforAbotSong["song_link"].toString()
    };

    //Guardar la cancion en la lista dentro del usuario
    try {
      //Obtener el arreglo de canciones dentro del usuario

      //Revisar si la cancion ya esta en la lista

      //Agregar la informacion de la cancion nueva

      return true;
    } catch (e) {
      print("Error en actualizar doc del usuario: $e");
      return false;
    }
  }
}
