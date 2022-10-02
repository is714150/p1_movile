
part of 'record_bloc.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class OnSendSongFile extends RecordEvent{
  final Map<String, dynamic> songFileToSave;

  OnSendSongFile({required this.songFileToSave});

  @override
  List<Object> get props => [songFileToSave];
}

class LoadSongInfo extends RecordEvent{}

class OnListenToSong extends RecordEvent{}