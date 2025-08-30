import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/games/data/datasources/local/database_helper.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_event.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final DatabaseHelper dbHelper;

  FavoriteBloc(this.dbHelper) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favorites = await dbHelper.getFavorites(event.userID);
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError("Erro ao carregar favoritos: $e"));
    }
  }

  Future<void> _onAddFavorite(AddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await dbHelper.addFavorite(event.userID, event.gameID, event.name, event.backgroundImage);
      final favorites = await dbHelper.getFavorites(event.userID);
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError("Erro ao adicionar favorito: $e"));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await dbHelper.removeFavorite(event.favoriteID);
      final favorites = await dbHelper.getFavorites(event.userID);
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError("Erro ao remover favorito: $e"));
    }
  }
}
