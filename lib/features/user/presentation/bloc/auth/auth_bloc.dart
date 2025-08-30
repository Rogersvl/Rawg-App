import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/games/data/datasources/local/database_helper.dart';
import 'package:games_app/features/user/domain/entities/user.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await dbHelper.addUser(event.name, event.email, event.password, null);
        final userMap = await dbHelper.login(event.email, event.password);

        if (userMap != null) {
          final user = User.fromMap(userMap);
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Erro ao registrar usuário."));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userMap = await dbHelper.login(event.email, event.password);
        if (userMap != null) {
          final user = User.fromMap(userMap);
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Email ou senha incorretos"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthUnauthenticated());
    });
  }
}
