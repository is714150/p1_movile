part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();
  
  @override
  List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordErrorState extends RecordState {}

class RecordLoadingState extends RecordState {}

class RecordInfoReceivedState extends RecordState{
}

class RecordSuccessState extends RecordState{
  final Map<String, dynamic> songInfoJson;

  RecordSuccessState({required this.songInfoJson});

  @override
  List<Object> get props => [songInfoJson];
}