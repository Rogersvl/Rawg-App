import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_event.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      await Future.delayed(Duration(seconds: 3));

      if (event.email == 'Roger' && event.password == '123') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Incorrect email or password!'));
      }
    });
  }
}
