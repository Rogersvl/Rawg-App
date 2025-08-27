import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/logout_user.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;

  LoginBloc({required this.loginUser, required this.logoutUser}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginPressed);
    on<LogoutButtonPressed>(_onLogoutPressed);
  }

  Future<void> _onLoginPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await loginUser(event.email, event.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure('Erro ao realizar login: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutPressed(LogoutButtonPressed event, Emitter<LoginState> emit) async {
    await logoutUser();
    emit(LogoutSuccess());
  }
}
