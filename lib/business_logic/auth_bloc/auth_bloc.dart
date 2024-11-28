import 'package:expenses_tracker/business_logic/auth_bloc/auth_event.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_state.dart';
import 'package:expenses_tracker/business_logic/auth_services/auth_exception.dart';
import 'package:expenses_tracker/business_logic/auth_services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authService = AuthService();
  AuthBloc() : super(const AuthStateUninitialized()) {
    //register
    on<AuthEventRegister>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await authService.createUser(
          email: event.email,
          password: event.password,
        );
        // await provider.sendEmailVerification();
        // emit(const AuthStateNeedsVerification(isLoading: false));
        final user = await authService.signInWithEmail(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateSignedIn(user: user));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e));
      }
    });

    //should register
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null));
    });

    //should sign in
    on<AuthEventShouldSignIn>((event, emit) {
      emit(const AuthStateSignedOut(exception: null));
    });

    //initialize
    on<AuthEventInitialize>((event, emit) async {
      emit(AuthStateLoading());
      await authService.initialize();
      final user = authService.currentUser;

      if (user == null) {
        emit(const AuthStateSignedOut(exception: null));
      }
      // else if (!user.isEmailVerified) {
      //   emit(const AuthStateNeedsVerification(isLoading: false));
      // }
      else {
        emit(AuthStateSignedIn(
          user: user,
        ));
      }
    });

    //sign in with email
    on<AuthEventSignInWithEmail>((event, emit) async {
      emit(AuthStateLoading());

      try {
        final user = await authService.signInWithEmail(
          email: event.email,
          password: event.password,
        );

        emit(AuthStateSignedIn(user: user));

        // if (!user.isEmailVerified) {
        //   emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        //   // emit(const AuthStateNeedsVerification(isLoading: false));
        // } else {

        // }
      } on Exception catch (e) {
        emit(AuthStateSignedOut(
          exception: e,
        ));
      }
    });

    //sign in with google
    on<AuthEventSignInWithGoogle>((event, emit) async {
      emit(AuthStateLoading());
      try {
        final user = await authService.signInWithGoogle();
        emit(AuthStateSignedIn(user: user));
      } on UserNotLoggedInAuthException catch (_) {
        emit(const AuthStateSignedOut(
          exception: null,
        ));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(
          exception: e,
        ));
      }
    });

    //sign out
    on<AuthEventSignOut>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await authService.signOut();
        emit(const AuthStateSignedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(exception: e));
      }
    });
  }
}
