import 'package:expenses_tracker/business_logic/auth_bloc/auth_bloc.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_event.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_state.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/auth/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

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
        if (state is AuthStateSignedIn) {
          Navigator.of(context).pushReplacementNamed(homeRoute);
        } else if (state is AuthStateSignedOut && state.exception != null) {
          showErrorDialog(context, state.exception.toString());
        } else if (state is AuthStateRegistering) {
          Navigator.of(context).pushReplacementNamed(registerRoute);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Login'),
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
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AuthBloc>().add(AuthEventSignInWithEmail(
                          email: email,
                          password: password,
                        ));
                  },
                  child: const Text('Login'),
                ),
                SignInButton(
                  Buttons.google,
                  text: "Sign in with Google",
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                          AuthEventSignInWithGoogle(),
                        );
                  },
                ),
                TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventShouldRegister());
                    },
                    child: const Text('Don\'t have an account? Register here.'))
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
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
