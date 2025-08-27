import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_event.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is LoginSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.user.profileImage != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(state.user.profileImage!),
                    )
                  else
                    CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                  SizedBox(height: 16),
                  Text("Bem-vindo, ${state.user.name}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(LogoutButtonPressed());
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            );
          }

          if (state is LogoutSuccess) {
            return _buildLoginForm(context);
          }

          return _buildLoginForm(context);
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: userEmailController,
            decoration: InputDecoration(
              hintText: 'Insira seu Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: userPasswordController,
            decoration: InputDecoration(
              hintText: 'Insira sua senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LoginBloc>().add(
                LoginButtonPressed(
                  email: userEmailController.text,
                  password: userPasswordController.text,
                ),
              );
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
