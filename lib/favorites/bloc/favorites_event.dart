part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class OnGetFavorites extends FavoritesEvent{}

class OnRemoveSong extends FavoritesEvent{
  final Map<String, dynamic> toRemoveSongInfo;

  OnRemoveSong({required this.toRemoveSongInfo});

  @override
  List<Object> get props => [toRemoveSongInfo];
}