import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/user_login_bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: userEmailController,
                decoration: InputDecoration(
                  hintText: 'Insira seu Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: userPasswordController,
                decoration: InputDecoration(
                  hintText: 'Insira sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
