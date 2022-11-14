import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:p1_moviles/utils/secrets.dart';
import 'package:record/record.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(RecordInitial()) {
    on<OnListenToSong>(_recordSong);
  }

  //Funcion para grabar
  FutureOr<void> _recordSong(OnListenToSong event, Emitter emit) async {
    try {
      final record = Record();
      final permission = await record.hasPermission();
      if (!permission) {
        emit(RecordErrorState());
        return;
      }
  
      await record.start();

      await Future.delayed(Duration(seconds: 5));

      String? _listedSongPath = await record.stop();

      if (_listedSongPath == null) {
        emit(RecordErrorState());
        return;
      }

      File _sendFile = new File(_listedSongPath);

      String _fileAsBytes = base64Encode(_sendFile.readAsBytesSync());

      final informacionDeRespuesta = await _getSongInfo(_fileAsBytes);

      if (informacionDeRespuesta == null) {
        emit(RecordErrorState());
        return;
      }

      final info = {
        "artist": informacionDeRespuesta["artist"],
        "title": informacionDeRespuesta["title"],
        "album": informacionDeRespuesta["album"],
        "release_date": informacionDeRespuesta["release_date"],
        "apple_music": informacionDeRespuesta["apple_music"],
        "spotify": informacionDeRespuesta["spotify"]["external_urls"]
            ["spotify"],
        "song_link": informacionDeRespuesta["song_link"],
        "albumImage": informacionDeRespuesta["spotify"]["album"]["images"][0]
            ["url"],
      };

      print(info);
      emit(RecordSuccessState(songInfoJson: info));
    } catch (e) {
      print(e);
    }
  }

  //Obtener la infomracion de la cancion de la API
  Future<dynamic> _getSongInfo(String _filesAsBytes) async {
    //Informacion necesaria para la API
    final Uri urlDeLaAPI = Uri.parse("https://api.audd.io/");
    Map<String, String> urlParameters = {
      'api_token': ApiKey,
      'audio': _filesAsBytes,
      'return': 'apple_music,spotify',
    };
    try {
      final response = await http.post(urlDeLaAPI, body: urlParameters);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["result"];
      }
    } catch (e) {}
  }
}
