import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_state.dart';
import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;

  LoginBloc({required this.authBloc}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());


      authBloc.add(LoginRequested(email: event.email, password: event.password));

      await emit.forEach(
        authBloc.stream,
        onData: (authState) {
          if (authState is AuthAuthenticated) {
            return LoginSuccess(authState.user);
          } else if (authState is AuthError) {
            return LoginFailure(authState.message);
          } else if (authState is AuthUnauthenticated) {
            return LoginFailure("Usuário não autenticado");
          }
          return state;
        },
      );
    });
  }
}
