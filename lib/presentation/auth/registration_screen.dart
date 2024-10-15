import 'package:expenses_tracker/business_logic/auth_bloc/auth_bloc.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_event.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_state.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/auth/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistationScreen extends StatefulWidget {
  const RegistationScreen({super.key});

  @override
  State<RegistationScreen> createState() => _RegistationScreenState();
}

class _RegistationScreenState extends State<RegistationScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoading) {
        } else if (state is AuthStateSignedIn) {
          Navigator.of(context).pushReplacementNamed(homeRoute);
        } else if (state is AuthStateSignedOut && state.exception != null) {
          showErrorDialog(context, state.exception.toString());
        } else if (state is AuthStateSignedOut) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        } else if (state is AuthStateRegistering && state.exception != null) {
          showErrorDialog(context, state.exception.toString());
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Registration'),
            ),
            body: Column(
              children: [
                TextField(
                  controller: emailController,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                TextButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    context.read<AuthBloc>().add(AuthEventRegister(
                          email: email,
                          password: password,
                        ));
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventShouldSignIn());
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthStateLoading) {
                FocusScope.of(context).unfocus();

                return Stack(
                  children: [
                    ModalBarrier(
                      color: Colors.black.withOpacity(0.5),
                      dismissible: false,
                    ),
                    const Center(child: CircularProgressIndicator())
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }
}
