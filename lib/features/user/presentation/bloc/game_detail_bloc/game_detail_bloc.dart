import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:games_app/features/games/data/datasources/game_remote_data_source.dart';
import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_event.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_state.dart';

class GameDetailBloc extends Bloc<GameDetailEvent, GameDetailState> {
  final GameRemoteDataSource repository;

  GameDetailBloc(this.repository) : super(GameDetailInitial()) {
    on<FetchGameDetails>(_onFetchGameDetail);
  }

  Future<void> _onFetchGameDetail(
    FetchGameDetails event,
    Emitter<GameDetailState> emit,
  ) async {
    emit(GameDetailLoading());
    try {
      print("Buscando detalhes do jogo ID: ${event.gameID}");

      final gameDetail = await repository.showDetailedGame(event.gameID);
      final getScreenshots = await repository.getScreenShots(event.gameID);

      print("Quantidade de screenshots: ${gameDetail.screenshots.length}");

      emit(GameDetailLoaded(gameDetail, getScreenshots));
    } catch (e) {
      emit(GameDetailError('Não foi possível carregar os detalhes do jogo.'));
    }
  }
}
